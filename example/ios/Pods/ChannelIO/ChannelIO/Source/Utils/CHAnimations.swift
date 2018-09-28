//
//  CHAnimations.swift
//  CHPlugin
//
//  Created by R3alFr3e on 11/14/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit

final private class ViewAnimationStep {
  fileprivate var completed: (() -> Void) = { }
  fileprivate let animations: (() -> Void)
  fileprivate let duration: TimeInterval
  
  init(withAnimations animations: @escaping (() -> Void), duration: TimeInterval = 0.0) {
    self.animations = animations
    self.duration = duration
  }
  
  func onCompleted(completed: @escaping (() -> Void)) -> Self {
    self.completed = completed
    
    return self
  }
  
  func execute(option: UIViewAnimationOptions = .curveLinear) {
    UIView.animate(withDuration: duration, delay: 0, options: option, animations:animations) { (_) in
      self.completed()
    }
  }
}

class AnimationSequence {
  fileprivate var completion: (() -> Void) = { }
  fileprivate var sequence = [ViewAnimationStep]()
  fileprivate var stepDuration: TimeInterval
  
  init(withStepDuration stepDuration: TimeInterval = 0.0) {
    self.stepDuration = stepDuration
  }
  
  @discardableResult
  func doStep(_ animations: @escaping (() -> Void)) -> Self {
    let step = ViewAnimationStep(withAnimations: animations, duration: stepDuration)
    sequence.append(step)
    
    return self
  }
  
  @discardableResult
  func onCompletion(_ sequenceCompletion: @escaping (() -> Void)) -> Self {
    completion = sequenceCompletion
    
    return self
  }
  
  func execute(option: UIViewAnimationOptions = .curveLinear) {
    executeSteps(option: option)
  }
  
  fileprivate func executeSteps(option: UIViewAnimationOptions) {
    if sequence.isEmpty == false {
      let step = sequence.removeFirst()
      step
        .onCompleted {
          self.executeSteps(option: option)
        }
        .execute(option: option)
    }
    else {
      completion()
    }
  }
}
