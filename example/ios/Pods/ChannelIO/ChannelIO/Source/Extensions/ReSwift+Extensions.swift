//
//  ReSwift+Extensions.swift
//  CHPlugin
//
//  Created by Haeun Chung on 07/12/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

extension Store {
  func dispatch(_ action: Action, delay: Double) {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
      self.dispatch(action)
    })
  }
  
  func dispatchOnMain(_ action: Action) {
    self.dispatch(action)
  }
}
