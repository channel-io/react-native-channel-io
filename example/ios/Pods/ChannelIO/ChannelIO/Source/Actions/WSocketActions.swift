//
//  WsSocketActions.swift
//  CHPlugin
//
//  Created by Haeun Chung on 14/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

struct SocketConnected : Action {}

struct SocketReady : Action {}

struct SocketDisconnected: Action {}

struct SocketReconnecting: Action {}
