//
//  ChannelIO.swift
//  ChannelIO
//
//  Created by intoxicated on 2017. 1. 10..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import CGFloatLiteral
import ManualLayout
import Reusable
import SnapKit
import Then
import ReSwift
import RxSwift
import UserNotifications
import SVProgressHUD
import CRToast
import AVFoundation

let mainStore = Store<AppState>(
  reducer: appReducer,
  state: nil,
  middleware: [loggingMiddleware]
)

func dlog(_ str: String) {
  guard ChannelIO.settings?.debugMode == true else { return }
  print("[CHPlugin]: \(str)")
}

@objc
public protocol ChannelPluginDelegate: class {
  @objc optional func onChangeBadge(count: Int) -> Void /* notify badge count when changed */
  @objc optional func onClickChatLink(url: URL) -> Bool /* notifiy if a link is clicked */
  @objc optional func willOpenMessenger() -> Void /* notify when chat list is about to show */
  @objc optional func willCloseMessenger() -> Void /* notify when chat list is about to hide */
  @objc optional func onReceivePush(event: PushEvent) -> Void
}

@objc
public final class ChannelIO: NSObject {
  //MARK: Properties
  @objc public static weak var delegate: ChannelPluginDelegate? = nil
  @objc public static var booted: Bool {
    return mainStore.state.checkinState.status == .success
  }
  
  internal static var chatNotificationView: ChatNotificationView?
  internal static var baseNavigation: BaseNavigationController?
  internal static var subscriber : CHPluginSubscriber?

  internal static var disposeBeg = DisposeBag()
  internal static var pushToken: String?
  internal static var currentAlertCount = 0

  static var isValidStatus: Bool {
    return mainStore.state.checkinState.status == .success &&
      mainStore.state.channel.id != ""
  }

  internal static var settings: ChannelPluginSettings? = nil
  internal static var profile: Profile? = nil
  internal static var launcherView: LauncherView? = nil
  internal static var launcherVisible: Bool = false
  
  // MARK: StoreSubscriber
  class CHPluginSubscriber : StoreSubscriber {
    //refactor into two selectors
    func newState(state: AppState) {
      self.handleBadgeDelegate(state.guest.alert)
      self.handlePush(push: state.push)
      let viewModel = LauncherViewModel(plugin: state.plugin, guest: state.guest)
      
      ChannelIO.launcherView?.configure(viewModel)
    }
    
    func handlePush (push: CHPush?) {
      if ChannelIO.baseNavigation == nil && ChannelIO.settings?.hideDefaultInAppPush == false {
        ChannelIO.showNotification(pushData: push)
      }
      if let push = push {
        ChannelIO.delegate?.onReceivePush?(event: PushEvent(with: push))
      }
    }
    
    func handleBadgeDelegate(_ count: Int) {
      if ChannelIO.currentAlertCount != count {
        ChannelIO.delegate?.onChangeBadge?(count: count)
      }
      ChannelIO.currentAlertCount = count
    }
  }
  
  // MARK: Public

  /**
   *   Boot ChannelIO
   *
   *   Boot up ChannelIO and make it ready to use
   *
   *   - parameter settings: ChannelPluginSettings object
   *   - parameter guest: Guest object
   *   - parameter compeltion: ChannelPluginCompletionStatus indicating status of boot phase
   */
  @objc public class func boot(
    with settings: ChannelPluginSettings,
    profile: Profile? = nil,
    completion: ((ChannelPluginCompletionStatus, Guest?) -> Void)? = nil) {
    ChannelIO.prepare()
    ChannelIO.settings = settings
    ChannelIO.profile = profile
    
    if settings.pluginKey == "" {
      mainStore.dispatch(UpdateCheckinState(payload: .notInitialized))
      completion?(.notInitialized, nil)
      return
    }
    
    PluginPromise.checkVersion().flatMap { (event) in
      return ChannelIO.checkInChannel(profile: profile)
    }
    .observeOn(MainScheduler.instance)
    .subscribe(onNext: { (_) in
      PrefStore.setChannelPluginSettings(pluginSetting: settings)
      ChannelIO.registerPushToken()
      
      if ChannelIO.launcherVisible {
        ChannelIO.show(animated: true)
      }
      completion?(.success, Guest(with: mainStore.state.guest))
    }, onError: { error in
      let code = (error as NSError).code
      if code == -1001 {
        dlog("network timeout")
        mainStore.dispatch(UpdateCheckinState(payload: .networkTimeout))
        completion?(.networkTimeout, nil)
      } else if code == CHErrorCode.versionError.rawValue {
        dlog("version is not compatiable. please update sdk version")
        mainStore.dispatch(UpdateCheckinState(payload: .notAvailableVersion))
        completion?(.notAvailableVersion, nil)
      } else if code == CHErrorCode.serviceBlockedError.rawValue {
        dlog("require payment. free plan is not eligible to use SDK")
        mainStore.dispatch(UpdateCheckinState(payload: .requirePayment))
        completion?(.requirePayment, nil)
      } else {
        dlog("unknown")
        mainStore.dispatch(UpdateCheckinState(payload: .unknown))
        completion?(.unknown, nil)
      }
    }).disposed(by: disposeBeg)
  }

  /**
   *   Init a push token.
   *   This method has to be called within
   *   `application:didRegisterForRemoteNotificationsWithDeviceToken:`
   *   in `AppDelegate` in order to get receive push notification from Channel io
   *
   *   - parameter deviceToken: a Data that represents device token
   */
  @objc public class func initPushToken(deviceToken: Data) {
    let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
    ChannelIO.pushToken = token
    
    if ChannelIO.isValidStatus {
      ChannelIO.registerPushToken()
    }
  }

  /**
   *   Shutdown ChannelIO
   *   Call this method when user terminate session or logout
   */
  @objc public class func shutdown() {
    let guestToken = PrefStore.getCurrentGuestKey() ?? ""
    ChannelIO.reset()
    
    PluginPromise.unregisterPushToken(guestToken: guestToken)
      .observeOn(MainScheduler.instance)
      .subscribe(onNext: { _ in
        dlog("shutdown success")
      }, onError: { (error) in
        dlog("shutdown fail")
      }).disposed(by: disposeBeg)
  }
    
  /**
   *   Show channel launcher on application
   *   location of the view can be customized with LauncherConfig property in ChannelPluginSettings
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func show(animated: Bool) {
    guard let view = UIApplication.shared.keyWindow?.rootViewController?.view else { return }
    ChannelIO.launcherVisible = true
    guard ChannelIO.isValidStatus else { return }
    guard ChannelIO.baseNavigation == nil else { return }
    
    dispatch {
      let launcherView = ChannelIO.launcherView ?? LauncherView()
      
      let viewModel = LauncherViewModel(
        plugin: mainStore.state.plugin,
        guest: mainStore.state.guest
      )
      
      let xMargin = ChannelIO.settings?.launcherConfig?.xMargin ?? 24
      let yMargin = ChannelIO.settings?.launcherConfig?.yMargin ?? 24
      let position = ChannelIO.settings?.launcherConfig?.position ?? .right
      
      launcherView.superview == nil ?
        launcherView.insert(on: view, animated: animated) :
        launcherView.show(animated: animated)
      
      launcherView.snp.remakeConstraints ({ (make) in
        make.size.equalTo(CGSize(width:54.f, height:54.f))
        
        if position == LauncherPosition.right {
          make.right.equalToSuperview().inset(xMargin)
        } else if position == LauncherPosition.left {
          make.left.equalToSuperview().inset(xMargin)
        }
        
        if #available(iOS 11.0, *) {
          make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-yMargin)
        } else {
          make.bottom.equalToSuperview().inset(yMargin)
        }
      })
      
      launcherView.configure(viewModel)
      launcherView.buttonView.signalForClick().subscribe(onNext: { _ in
        guard ChannelIO.isValidStatus else { return }
        ChannelIO.open(animated: true)
      }).disposed(by: disposeBeg)
      
      ChannelIO.launcherView = launcherView
    }
  }
  
  /**
   *  Hide channel launcher from application
   *
   *  - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func hide(animated: Bool) {
    ChannelIO.launcherView?.hide(animated: animated)
    ChannelIO.launcherVisible = false
  }
  
  /** 
   *   Open channel messenger on application
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func open(animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    guard !mainStore.state.uiState.isChannelVisible else { return }
    guard let topController = CHUtils.getTopController() else { return }
    
    dispatch {
      ChannelIO.launcherView?.isHidden = true
      ChannelIO.delegate?.willOpenMessenger?()
      ChannelIO.sendDefaultEvent(.open)
      mainStore.dispatch(ChatListIsVisible())

      let userChatsController = UserChatsViewController()
      let controller = MainNavigationController(rootViewController: userChatsController)
      ChannelIO.baseNavigation = controller

      topController.present(controller, animated: animated, completion: nil)
    }
  }

  /**
   *   Close channel messenger from application
   *
   *   - parameter animated: if true, the view is being added to the window using an animation
   */
  @objc public class func close(animated: Bool, completion: (() -> Void)? = nil) {
    guard ChannelIO.isValidStatus else { return }
    guard ChannelIO.baseNavigation != nil else { return }
    
    dispatch {
      ChannelIO.delegate?.willCloseMessenger?()
      ChannelIO.baseNavigation?.dismiss(
        animated: animated, completion: {
        mainStore.dispatch(ChatListIsHidden())
        
        //ChannelIO.launcherView?.isHidden = false
        if ChannelIO.launcherVisible {
          ChannelIO.launcherView?.show(animated: true)
        }
        ChannelIO.baseNavigation?.removeFromParentViewController()
        ChannelIO.baseNavigation = nil
        completion?()
      })
    }
  }
  
  /**
   *  Open a user chat with given chat id
   *
   *  - parameter chatId: a String user chat id. Will open new chat if chat id is invalid
   *  - parameter completion: a closure to signal completion state
   */
  @objc public class func openChat(with chatId: String? = nil, animated: Bool) {
    guard ChannelIO.isValidStatus else { return }
    ChannelIO.showUserChat(userChatId: chatId, animated: animated)
  }
  
  /**
   *  Track an event
   *
   *   - parameter eventName: Event name
   *   - parameter eventProperty: a Dictionary contains information about event
   */
  @objc public class func track(eventName: String, eventProperty: [String: Any]? = nil) {
    guard ChannelIO.isValidStatus else { return }
    guard let settings = ChannelIO.settings else { return }
    
    let version = Bundle(for: ChannelIO.self)
      .infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    
    ChannelIO.track(eventName: eventName, eventProperty: eventProperty, sysProperty: [
      "pluginId": settings.pluginKey,
      "pluginVersion": version,
      "device": UIDevice.current.modelName,
      "os": "\(UIDevice.current.systemName)_\(UIDevice.current.systemVersion)",
      "screenWidth": UIScreen.main.bounds.width,
      "screenHeight": UIScreen.main.bounds.height,
      "plan": mainStore.state.channel.servicePlan.rawValue
    ])
  }
  
  /**
   *  Check whether channel is currently operating
   *
   *  - return: ture if a channel is in operating hour, otherwise false
   */
  @objc public class func isOperating() -> Bool {
    return false //calculate channel working time...
  }
  
  /**
   *   Check whether push notification is valid Channel push notification
   *   by inspecting userInfo
   *
   *   - parameter userInfo: a Dictionary contains push information
   */
  @objc public class func isChannelPushNotification(_ userInfo:[AnyHashable: Any]) -> Bool {
    guard let provider = userInfo["provider"] as? String, provider  == CHConstants.channelio else { return false }
    guard let personType = userInfo["personType"] as? String else { return false }
    guard let personId = userInfo["personId"] as? String else { return false }
    guard let pushChannelId = userInfo["channelId"] as? String else { return false }

    let userId = PrefStore.getCurrentUserId() ?? ""
    let veilId = PrefStore.getCurrentVeilId() ?? ""
    let channelId = PrefStore.getCurrentChannelId() ?? ""
    
    if personType == "User" {
      return personId == userId && pushChannelId == channelId
    }
    
    if personType == "Veil" {
      return personId == veilId && pushChannelId == channelId
    }
    
    return false
  }
  
  /**
   *   Handle push notification for channel
   *   This method has to be called within `userNotificationCenter:response:completionHandler:`
   *   for **iOS 10 and above**, and `application:userInfo:completionHandler:`
   *   for **other version of iOS** in `AppDelegate` in order to make channel
   *   plugin worked properly
   *
   *   - parameter userInfo: a Dictionary contains push information
   */
  @objc public class func handlePushNotification(_ userInfo:[AnyHashable : Any]) {
    guard ChannelIO.isChannelPushNotification(userInfo) else { return }
    guard let userChatId = userInfo["chatId"] as? String else { return }
    
    //check if checkin 
    if ChannelIO.isValidStatus {
      ChannelIO.showUserChat(userChatId:userChatId)
      return
    }
    
    guard let settings = PrefStore.getChannelPluginSettings() else {
      dlog("ChannelPluginSetting is missing")
      return
    }
    
    if let userId = PrefStore.getCurrentUserId() {
      settings.userId = userId
    }
    
    ChannelIO.boot(with: settings, profile: profile) { (status, guest) in
      if status == .success {
        ChannelIO.showUserChat(userChatId:userChatId)
      }
    }
  }
}
