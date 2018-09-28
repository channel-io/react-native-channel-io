//
//  SessionActions.swift
//  CHPlugin
//
//  Created by R3alFr3e on 2/11/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

struct CreateSession: Action {
  public let payload: CHSession
}

struct UpdateSession: Action {
  public let payload: CHSession
}

struct DeleteSession: Action {
  public let payload: CHSession
}

struct UpdateManager: Action {
  public let payload: CHManager
}

struct UpdateFollowingManagers: Action {
  public let payload: [CHManager]
}
