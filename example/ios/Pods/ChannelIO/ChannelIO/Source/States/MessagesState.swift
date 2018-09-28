//
//  MessagesState.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct MessagesState: StateType {
  var messageDictionary: [String:CHMessage] = [:]
  var formQueue: [String:CHMessage] = [:]
  
  func findBy(type: MessageType) -> [CHMessage]? {
    return self.messageDictionary.filter({$1.messageType == type}).map({ $1 })
  }
  
  func findBy(id: String?) -> CHMessage? {
    guard id != nil else { return nil }
    return self.messageDictionary[id!]
  }

  func findBy(userChatId: String?) -> [CHMessage] {
    guard userChatId != nil else {
      return self.messageDictionary.filter({ $1.id.hasSuffix("dummy")}).map({ $1 })
    }
    return self.messageDictionary
      .filter({ $1.chatId == userChatId! || $1.id.hasSuffix("dummy") })
      .map({ $1 })
  }

  mutating func remove(message: CHMessage) -> MessagesState {
    self.messageDictionary.removeValue(forKey: message.id)
    return self
  }
  
  mutating func remove(type: MessageType) -> MessagesState {
    for (k,v) in self.messageDictionary {
      if v.messageType == type {
        self.messageDictionary.removeValue(forKey: k)
      }
    }
    return self
  }
  
  //make sure when exiting user chat by back, always need to remove dummy!!!
  mutating func removeLocalMessages() -> MessagesState {
    for (k,v) in self.messageDictionary {
      if v.chatId.contains("dummy") || v.id.contains("dummy") {
        self.messageDictionary.removeValue(forKey: k)
      }
    }
    self.formQueue = [:]
    return self
  }
  
  mutating func remove(userChatId: String) -> MessagesState {
    guard userChatId != "" else { return self }
    let lastIds = mainStore.state.userChatsState.lastMessages
    
    self.messageDictionary.forEach { (k, v) in
      if (v.chatId == userChatId &&
        lastIds[v.id] == nil) && v.state != .Failed {
        self.messageDictionary.removeValue(forKey: k)
      }
    }
    return self
  }
  
  mutating func upsert(messages: [CHMessage]) -> MessagesState {
    for message in messages {
      if let isWelcome = message.botOption?["welcome"], isWelcome {
        self.messageDictionary["welcome_dummy"] = message
      } else {
        self.messageDictionary[message.id] = message
      }
      
      if message.form != nil {
        self.formQueue[message.id] = message
      }
    }
    return self
  }
  
  mutating func insert(message: CHMessage?) -> MessagesState {
    guard let message = message else { return self }
    self.messageDictionary[message.id] = message
    return self
  }

  mutating func replace(message: CHMessage) -> MessagesState {
    if message.requestId != nil {
      self.messageDictionary[message.requestId!] = nil
    }
    
    //when CreateMessage happens, all form should be treated as normal text
    for (key, message) in self.formQueue {
      var updated = message
      updated.messageType = .Default
      self.messageDictionary[key] = updated
    }
    
    self.messageDictionary[message.id] = message
    if message.form != nil {
      self.formQueue[message.id] = message
    }
    
    return self
  }
  
  mutating func clear() -> MessagesState {
    self.messageDictionary.removeAll()
    self.formQueue.removeAll()
    return self
  }
}
