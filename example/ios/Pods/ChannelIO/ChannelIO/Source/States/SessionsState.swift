//
//  SessionsState.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct SessionsState: StateType {
  var sessions: [String:CHSession] = [:]

  func findBy(userChatId: String) -> CHSession? {
    return self.sessions
      .filter({ $1.chatType == "UserChat" && $1.chatId == userChatId && $1.personType != "Manager" }).first?.value
  }
  
  mutating func remove(session: CHSession) -> SessionsState {
    self.sessions.removeValue(forKey: session.id)
    return self
  }
  
  mutating func upsert(session: CHSession?) -> SessionsState {
    guard let session = session else { return self }
    self.sessions[session.id] = session
    return self
  }
  
  mutating func upsert(sessions: [CHSession]) -> SessionsState {
    sessions.forEach({ self.sessions[$0.id] = $0 })
    return self
  }
  
  mutating func clear() -> SessionsState {
    self.sessions.removeAll()
    return self
  }
}
