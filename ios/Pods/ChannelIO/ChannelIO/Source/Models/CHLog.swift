//
//  Log.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 17..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct CHLog {
  var action = ""
  var object = ""
  var objectId = ""
  var objectType = ""
}

extension CHLog: Mappable {
  init?(map: Map) {

  }
  mutating func mapping(map: Map) {
    action       <- map["action"]
    object       <- map["object"]
    objectId     <- map["objectId"]
    objectType   <- map["objectType"]
  }
}
