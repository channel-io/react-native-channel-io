//
//  Guest.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import RxSwift

protocol CHGuest: CHEntity {
  var named: Bool { get set }
  var mobileNumber: String? { get set }
  var profile: [String : Any]? { get set }
  
  var alert: Int { get set }
  var unread: Int { get set }
}

extension CHGuest {
  var type: String! {
    if self is CHUser {
      return "User"
    } else {
      return "Veil"
    }
  }
}

extension CHGuest {
  func getWelcome() -> String? {
    if self.named {
      return mainStore.state.plugin.welcomeNamedI18n?.getMessage()?.replace("${name}", withString: self.name)
    } else {
      return mainStore.state.plugin.welcomeI18n?.getMessage()
    }
  }
  
  func touch() -> Observable<CHGuest> {
    return GuestPromise.touch()
  }
}
