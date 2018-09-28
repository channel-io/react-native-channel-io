//
//  ChatStatusExtensionView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 23/11/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class ChatStatusViewFactory {
  class func createFollowedExtensionView(
    fit width: CGFloat,
    userChat: CHUserChat?,
    channel: CHChannel,
    plugin: CHPlugin) -> UIView {
    
    let extensionViewHeight = ChatStatusFollowedView.viewHeight(host: userChat?.lastTalkedHost)
    let statusView = ChatStatusFollowedView(frame: CGRect(x: 0, y: 0, width: width, height: extensionViewHeight))
    statusView.configure(lastTalkedHost: userChat?.lastTalkedHost, channel: channel, plugin: plugin)
    return statusView
  }
  
  class func createDefaultExtensionView(
    fit width: CGFloat,
    userChat: CHUserChat?,
    channel: CHChannel,
    plugin: CHPlugin,
    managers: [CHManager]) -> UIView {
    
    let extensionViewHeight = ChatStatusDefaultView.viewHeight(
      fits: width, channel: channel, userChat: userChat, followingManagers: managers)
    let statusView = ChatStatusDefaultView(
      frame: CGRect(x: 0, y:0, width: width, height: extensionViewHeight))
    
    statusView.configure(
      channel: mainStore.state.channel,
      plugin: mainStore.state.plugin,
      userChat: userChat,
      followingManagers: managers)
    
    _ = statusView.signalForBusinessHoursClick().subscribe({ (_) in
      let channel = mainStore.state.channel
      let alertView = UIAlertController(title:nil, message:nil, preferredStyle: .alert)
      alertView.title = ""
      alertView.message = "Timezone: " + channel.timeZone + "\n\n" + channel.workingTimeString
      
      alertView.addAction(
        UIAlertAction(title: CHAssets.localized("ch.button_confirm"), style: .cancel) { _ in
          //nothing
        }
      )
      let topController = CHUtils.getTopController()
      topController?.present(alertView, animated: true, completion: nil)
    })
    return statusView
  }
}

class ChatStatusDefaultView : BaseView {
  struct Metric {
    static let avatarTrailing = 20.f
    static let avatarLeading = 18.f
    static let statusTitleTop = 10.f
    static let statusTitleBottom = 4.f
    static let statusDescBottom = 15.f
    static let avatarOneWidth = 44.f + Metric.avatarLeading + Metric.avatarTrailing
    static let avatarTwoWidth = 44.f + Metric.avatarLeading + Metric.avatarTrailing + 38.f
    static let avatarThreeWidth = 44.f + Metric.avatarLeading + Metric.avatarTrailing + 76.f
    static let businessHourTop = 15.f
    static let businessHourBottom = 15.f
    static let businessHourSide = 10.f
  }
  
  let disposeBag = DisposeBag()
  let businessSubject = PublishSubject<Any?>()
  
  let statusLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 14)
  }
  
  let statusImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "offhoursW")
    $0.contentMode = .center
  }
  
  let statusDescLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.numberOfLines = 0
  }
  
  let multiAvatarView = ChatStatusAvatarsView(avatarSize: 46, coverMargin: 6)
  
  let divider = UIView().then {
    $0.isHidden = false
    $0.alpha = 0.3
    $0.backgroundColor = UIColor.white
  }
  
  let businessHoursView = UIView().then {
    $0.isHidden = false
  }
  let businessHoursLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.numberOfLines = 0
    $0.textAlignment = .center
  }
  
  var avatarWidthContraint: Constraint? = nil
  var businessHourLabelHeightConstraint: Constraint? = nil
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.statusLabel)
    self.addSubview(self.statusImageView)
    self.addSubview(self.statusDescLabel)
    self.addSubview(self.multiAvatarView)
    self.addSubview(self.divider)
    self.businessHoursView.addSubview(self.businessHoursLabel)
    self.addSubview(self.businessHoursView)
    
    self.businessHoursView.signalForClick()
      .subscribe { [weak self] (_) in
        self?.businessSubject.onNext(nil)
      }.disposed(by: self.disposeBag)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.statusLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(18)
      make.top.equalToSuperview().inset(10)
    }
    
    self.statusImageView.snp.makeConstraints { [weak self] (make) in
      make.centerY.equalTo((self?.statusLabel.snp.centerY)!)
      make.leading.equalTo((self?.statusLabel.snp.trailing)!)
      make.height.equalTo(22)
      make.width.equalTo(22)
    }
    
    self.statusDescLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalToSuperview().inset(18)
      make.top.equalTo((self?.statusLabel.snp.bottom)!).offset(4)
    }
    
    self.multiAvatarView.snp.makeConstraints { [weak self] (make) in
      make.trailing.equalToSuperview().inset(20)
      make.top.equalToSuperview().inset(10)
      make.leading.equalTo((self?.statusDescLabel.snp.trailing)!).offset(12)
    }
    
    self.divider.snp.makeConstraints { [weak self] (make) in
      make.top.equalTo((self?.statusDescLabel.snp.bottom)!).offset(15)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.height.equalTo(0.5)
    }
    
    self.businessHoursView.snp.makeConstraints { [weak self] (make) in
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.top.equalTo((self?.divider.snp.bottom)!)
      make.bottom.equalToSuperview()
      self?.businessHourLabelHeightConstraint = make.height.equalTo(50).constraint
    }
    
    self.businessHoursLabel.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(18)
      make.trailing.equalToSuperview().inset(18)
      make.centerY.equalToSuperview()
    }
  }
  
  func signalForBusinessHoursClick() -> Observable<Any?> {
    return self.businessSubject
  }
  
  func configure(channel: CHChannel, plugin: CHPlugin, userChat: CHUserChat?, followingManagers: [CHManager]) {
    self.backgroundColor = UIColor(plugin.color)

    if !channel.working {
      self.statusLabel.text = CHAssets.localized("ch.chat.expect_response_delay.out_of_working")
      self.statusDescLabel.text = !channel.allowNewChat && userChat == nil ?
        CHAssets.localized("ch.chat.expect_response_delay.out_of_working.disabled") :
        CHAssets.localized("ch.chat.expect_response_delay.out_of_working.description")
      self.statusImageView.image = plugin.textColor == "white" ?
        CHAssets.getImage(named: "offhoursW") :
        CHAssets.getImage(named: "offhoursB")
    } else {
      self.statusLabel.text = CHAssets.localized("ch.chat.expect_response_delay.\(channel.expectedResponseDelay)")
      self.statusDescLabel.text = CHAssets.localized("ch.chat.expect_response_delay.\(channel.expectedResponseDelay).description")
      self.statusImageView.image = plugin.textColor == "white" ?
        CHAssets.getImage(named: "\(channel.expectedResponseDelay)W") :
        CHAssets.getImage(named: "\(channel.expectedResponseDelay)B")
    }
    
    let attributedString = NSMutableAttributedString(string: self.statusDescLabel.text!)
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.minimumLineHeight = 18.f
    attributedString.addAttribute(
      NSAttributedStringKey.paragraphStyle,
      value:paragraphStyle,
      range:NSMakeRange(0, attributedString.length))
    self.statusDescLabel.attributedText = attributedString;
    
    self.statusLabel.textColor = plugin.textUIColor
    self.statusDescLabel.textColor = plugin.textUIColor
    
    if channel.shouldShowSingleManager {
      if let manager = followingManagers.first {
        self.multiAvatarView.configure(persons: [manager])
      }
    } else {
      self.multiAvatarView.configure(persons: followingManagers)
    }
    
    if channel.shouldShowWorkingTimes {
      self.businessHoursLabel.text = CHAssets.localized("ch.chat.expect_response_delay.out_of_working.detail")
      self.businessHoursLabel.textColor = plugin.textUIColor
      self.businessHourLabelHeightConstraint?.update(offset: 50)
    } else {
      self.businessHoursLabel.text = ""
      self.businessHourLabelHeightConstraint?.update(offset: 0)
    }
  }
  
  static func viewHeight(fits width: CGFloat, channel: CHChannel, userChat: CHUserChat?, followingManagers: [CHManager]) -> CGFloat {
    var height: CGFloat = 0
    var avatarWidth:CGFloat = Metric.avatarLeading + Metric.avatarTrailing
    
    if followingManagers.count == 0 {
      avatarWidth = Metric.avatarTrailing
    } else if channel.shouldShowSingleManager {
      avatarWidth += Metric.avatarOneWidth
    } else if followingManagers.count == 2 {
      avatarWidth += Metric.avatarTwoWidth
    } else {
      avatarWidth += Metric.avatarThreeWidth
    }
    
    height += Metric.statusTitleTop
    if !channel.working {
      height += CHAssets.localized("ch.chat.expect_response_delay.out_of_working")
        .height(fits: width - avatarWidth, font: UIFont.boldSystemFont(ofSize: 14))
      height += !channel.allowNewChat && userChat == nil ?
        CHAssets.localized("ch.chat.expect_response_delay.out_of_working.disabled")
          .height(fits: width - avatarWidth, font: UIFont.systemFont(ofSize: 13)) :
        CHAssets.localized("ch.chat.expect_response_delay.out_of_working.description")
          .height(fits: width - avatarWidth, font: UIFont.systemFont(ofSize: 13))
    } else {
      height += CHAssets.localized("ch.chat.expect_response_delay.\(channel.expectedResponseDelay)")
        .height(fits: width - avatarWidth, font: UIFont.boldSystemFont(ofSize: 14))
      height += CHAssets.localized("ch.chat.expect_response_delay.\(channel.expectedResponseDelay).description")
        .height(fits: width - avatarWidth, font: UIFont.systemFont(ofSize: 13))
    }
    height += Metric.statusTitleBottom
    height += Metric.statusDescBottom
    height += 10 //TODO: need to find mis-calculation
    
    //if business hour set ..
    if let workingTime = channel.workingTime, workingTime.count != 0, !channel.working {
      height += Metric.businessHourTop //top
      height += CHAssets.localized("ch.chat.expect_response_delay.out_of_working.detail")
        .height(fits: width - Metric.businessHourSide * 2, font: UIFont.boldSystemFont(ofSize: 13))
      height += Metric.businessHourBottom //bottom
    }

    return height
  }
}
