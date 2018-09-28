//
//  UIView+RACSupport.swift
//  CHPlugin
//
//  Created by Haeun Chung on 08/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import RxSwift
import UIKit

class ClickGesture : UITapGestureRecognizer {
  var subscriber: AnyObserver<Any?>
  init(container: UIView, target: Any, action: Selector?) {
    self.subscriber = target as! AnyObserver<Any?>
    super.init(target: container, action: action)
  }
}

extension UIView {
  func signalForClick() -> Observable<Any?> {
    self.isUserInteractionEnabled = true

    return Observable.create { [weak self] subscriber in
      let gesture = ClickGesture(container: self!, target:subscriber, action:#selector(self!.onNext(_:)))
      gesture.numberOfTapsRequired = 1
      gesture.cancelsTouchesInView = true

      self?.gestureRecognizers = self?.gestureRecognizers?.filter{ !$0.isKind(of: ClickGesture.self) }
      self?.addGestureRecognizer(gesture)
      
      return Disposables.create() {
        subscriber.onCompleted()
        self?.removeGestureRecognizer(gesture)
      }
    }
  }
  
  @objc func onNext(_ gesture: ClickGesture) {
    gesture.subscriber.onNext(nil)
  }
}
