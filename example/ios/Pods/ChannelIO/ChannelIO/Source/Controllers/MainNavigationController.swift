//
//  MainNavigationController.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import ReSwift

protocol CHNavigationDelegate: class {
  func willPopViewController(willShow controller:UIViewController)
  //func willPushViewController()
}

class MainNavigationController: BaseNavigationController {

  // MARK: Properties
  weak var chDelegate: CHNavigationDelegate? = nil
  var statusBarStyle = UIStatusBarStyle.default
  var isPushingViewController = false
  
  var useDefault = false {
    didSet {
      if useDefault {
        self.navigationBar.barTintColor = nil
        self.navigationBar.titleTextAttributes =  [NSAttributedStringKey.foregroundColor: UIColor.white]
        self.navigationBar.isTranslucent = false
        self.statusBarStyle = .lightContent
        self.setNeedsStatusBarAppearanceUpdate()
      }
    }
  }
  
  // MARK: View Life Cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.delegate = self
    self.interactivePopGestureRecognizer?.delegate = self
    self.navigationBar.isTranslucent = false
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    mainStore.subscribe(self)
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    mainStore.unsubscribe(self)
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return self.statusBarStyle
  }
  
  override var shouldAutorotate: Bool {
    return false
  }
  
  override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
    return UIInterfaceOrientationMask.portrait
  }
}

// MARK: - StoreSubscriber

extension MainNavigationController: StoreSubscriber {
  func newState(state: AppState) {
    if !self.useDefault {
      // Bar Color
      self.navigationBar.barTintColor = UIColor(state.plugin.color)
      self.navigationBar.tintColor = state.plugin.textUIColor
      
      // Title
      if self.title == nil || self.title == "" {
        self.navigationBar.topItem?.title = state.channel.name
      }
      
      // Title Color
      let titleColor = state.plugin.textColor == "white" ? UIColor.white : UIColor.black
      self.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: titleColor]
      
      // Status bar color
      self.statusBarStyle = state.plugin.textColor == "white" ? .lightContent : .default
      self.setNeedsStatusBarAppearanceUpdate()
    }
  }
}

extension MainNavigationController: UIGestureRecognizerDelegate {
  func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
    guard gestureRecognizer is UIScreenEdgePanGestureRecognizer else { return true }
    return viewControllers.count > 1 && !isPushingViewController
  }
  
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return true
  }
  
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return false
  }
}

extension MainNavigationController : UINavigationControllerDelegate {
  func navigationController(
    _ navigationController: UINavigationController,
    didShow viewController: UIViewController, animated: Bool) {
    isPushingViewController = false
  }
  
  func navigationController(
    _ navigationController: UINavigationController,
    willShow viewController: UIViewController,
    animated: Bool) {
    if let coordinator = navigationController.topViewController?.transitionCoordinator {
      coordinator.notifyWhenInteractionEnds({ (context) in
        if !context.isCancelled {
          self.chDelegate?.willPopViewController(willShow: viewController)
        }
      })
    }
  }
}
