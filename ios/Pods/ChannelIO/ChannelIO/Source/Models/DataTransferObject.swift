//
//  UserChatResponse.swift
//  CHPlugin
//
//  Created by Haeun Chung on 07/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct ChatResponse {
  var userChat: CHUserChat? = nil
  var session: CHSession? = nil
  var managers: [CHManager]? = nil
  var message: CHMessage? = nil
}

extension ChatResponse : Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    userChat  <- map["userChat"]
    session   <- map["session"]
    managers  <- map["managers"]
    message   <- map["message"]
  }
  
}

struct GeoIPInfo {
  var ip: String = ""
  var country: String = ""
  var city: String = ""
  var timezone: String = ""
  var longitude: CGFloat = 0.0
  var latitude: CGFloat = 0.0
}

extension GeoIPInfo : Mappable {
  init?(map:Map) { }
  
  mutating func mapping(map:Map) {
    ip        <- map["ip"]
    country   <- map["country"]
    city      <- map["city"]
    timezone  <- map["timezone"]
    longitude <- map["longitude"]
    latitude  <- map["latitude"]
  }
}

struct CHCountry: Codable {
  var name = ""
  var code = ""
  var dial = ""
}

extension CHCountry: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    name       <- map["name"]
    code       <- map["code"]
    dial       <- (map["callingCode"], StringTransform())
  }
}

struct CHErrorResponse: Mappable {
  var message: String!
  var field: String?
  
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    message <- map["message"]
    field <- map["field"]
  }
}

