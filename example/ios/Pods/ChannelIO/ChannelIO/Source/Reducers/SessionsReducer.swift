//
//  SessionsReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func sessionsReducer(action: Action, state: SessionsState?) -> SessionsState {
  var state = state
  switch action {
  case let action as GetUserChats:
    let sessions = (action.payload["sessions"] as? [CHSession]) ?? []
    return state?.upsert(sessions: sessions) ?? SessionsState()
  case let action as GetUserChat:
    let session = action.payload.session
    return state?.upsert(session: session) ?? SessionsState()
  case let action as CreateSession:
    return state?.upsert(sessions: [action.payload]) ?? SessionsState()
  case let action as UpdateSession:
    return state?.upsert(sessions: [action.payload]) ?? SessionsState()
  case let action as DeleteSession:
    return state?.remove(session: action.payload) ?? SessionsState()
  case _ as CheckOutSuccess:
    return state?.clear() ?? SessionsState()
  default:
    return state ?? SessionsState()
  }
}
