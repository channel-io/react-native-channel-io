//
//  WsSocketReducer.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

func socketReducer(action: Action, state: WSocketState?) -> WSocketState {
  var state = state
  switch action {
  case _ as SocketConnected:
    state?.state = .connected
    return state ?? WSocketState()
  case _ as SocketReady:
    state?.state = .ready
    return state ?? WSocketState()
  case _ as SocketDisconnected:
    state?.state = .disconnected
    return state ?? WSocketState()
  case _ as SocketReconnecting:
    state?.state = .reconnecting
    return state ?? WSocketState()
  case _ as JoinedUserChat:
    state?.state = .joined
    return state ?? WSocketState()
  case _ as LeavedUserChat:
    state?.state = .leaved
    return state ?? WSocketState()
  default:
    return state ?? WSocketState()
  }
}
