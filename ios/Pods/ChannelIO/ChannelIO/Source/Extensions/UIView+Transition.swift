//
//  UIView+Transition.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit

enum UIViewTransition : Int {
  case TopToBottom
  case BottomToTop
  case LeftToRight
  case RightToLeft
}

extension UIView {
  func insert(on view: UIView, animated: Bool) {
    view.addSubview(self)
    
    if !animated {
      return
    }
    
    self.alpha = 0
    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.alpha = 1
    }) { (completed) in
      
    }
  }
  
  func remove(animated: Bool) {
    if !animated {
      self.removeFromSuperview()
      return
    }
    
    UIView.transition(with: self, duration: 0.5, options: UIViewAnimationOptions.curveEaseOut, animations: {
      self.alpha = 0
    }) { (completed) in
      self.removeFromSuperview()
    }
  }
  
  func show(animated: Bool) {
    if self.superview == nil {
      return
    }
    self.isHidden = false
    
    if !animated {
      self.alpha = 1
    }
    
    UIView.animate(withDuration: 0.5) {
      self.alpha = 1
    }
  }
  
  func hide(animated: Bool) {
    if !animated {
      self.alpha = 0
      return
    }
    
    UIView.animate(withDuration: 0.5) {
      self.alpha = 0
    }
  }
}

extension UIView {
  func fadeTransition(_ duration:CFTimeInterval) {
    let animation = CATransition()
    animation.timingFunction = CAMediaTimingFunction(name:
      kCAMediaTimingFunctionEaseInEaseOut)
    animation.type = kCATransitionFade
    animation.duration = duration
    layer.add(animation, forKey: kCATransitionFade)
  }
}
