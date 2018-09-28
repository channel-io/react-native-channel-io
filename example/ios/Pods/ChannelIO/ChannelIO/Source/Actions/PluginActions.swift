//
//  PluginAction.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct CheckInSuccess: Action {
  public let payload: [String: Any]
}

struct CheckOutSuccess: Action {}

struct GetPlugin: Action {
  public let plugin: CHPlugin
  public let bot: CHBot?
}

struct UpdateChannel: Action {
  public let payload: CHChannel
}

struct UpdateLocale: Action {
  public let payload: CHLocaleString
}
