//
//  WsSocketState.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

enum WebSocketState {
  case none //initial
  case joined
  case leaved
  case ready
  case connected
  case disconnected
  case reconnecting
}

struct WSocketState: StateType {
  var state: WebSocketState = .none
}
