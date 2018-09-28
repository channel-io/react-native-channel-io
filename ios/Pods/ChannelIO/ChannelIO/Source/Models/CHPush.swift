//
//  Push.swift
//  CHPlugin
//
//  Created by Haeun Chung on 10/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct CHPush {
  var type = ""
  
  var message: CHMessage?
  
  var user: CHUser?
  var veil: CHVeil?
  var bot: CHBot?
  var manager: CHManager?
  var userChat: CHUserChat?
  
  var isReviewLog: Bool {
    get {
      return self.message?.log != nil &&
        self.message?.log?.action == "resolve"
    }
  }
}

extension CHPush : Mappable {
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    message   <- map["entity"]
    manager   <- map["refers.manager"]
    bot       <- map["refers.bot"]
    user      <- map["refers.user"]
    veil      <- map["refers.veil"]
    userChat  <- map["refers.userChat"]
    type      <- map["type"]
  }
}
