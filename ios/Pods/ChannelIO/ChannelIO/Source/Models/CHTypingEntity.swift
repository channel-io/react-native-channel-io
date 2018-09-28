//
//  CHTypingEntity.swift
//  CHPlugin
//
//  Created by R3alFr3e on 11/14/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SocketIO
import ObjectMapper

struct CHTypingEntity: SocketData {
  var action = ""
  var chatId = ""
  var chatType = ""
  var personId: String? = nil
  var personType: String? = nil

  init(action: String, chatId: String, chatType: String,
       personId: String? = nil, personType: String? = nil) {
    self.action = action
    self.chatId = chatId
    self.chatType = chatType
    self.personId = personId
    self.personType = personType
  }
  
  func socketRepresentation() -> SocketData {
    return [
      "action": self.action,
      "chatId": self.chatId,
      "chatType": self.chatType,
    ]
  }
  
  static func transform(from message: CHMessage) -> CHTypingEntity {
    return CHTypingEntity(
      action: "stop",
      chatId: message.chatId,
      chatType: message.chatType,
      personId: message.personId,
      personType: message.personType
    )
  }
}

extension CHTypingEntity: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    action          <- map["action"]
    chatId          <- map["channelId"]
    chatType        <- map["chatType"]
    personId        <- map["personId"]
    personType      <- map["personType"]
  }
}
