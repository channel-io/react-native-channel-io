//
//  BotReducer.swift
//  CHPlugin
//
//  Created by Haeun Chung on 05/12/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

func botsReducer(action: Action, state: BotsState?) -> BotsState {
  var state = state
  switch action {
  case let action as GetBot:
    if let bot = action.payload {
      return state?.upsert(bots: [bot]) ?? BotsState()
    }
    return state ?? BotsState()
  case let action as GetMessages:
    if let bots = action.payload["bots"] as? [CHBot] {
      return state?.upsert(bots: bots) ?? BotsState()
    }
    return state ?? BotsState()
  case let action as GetUserChats:
    let bots = (action.payload["bots"] as? [CHBot]) ?? []
    return state?.upsert(bots: bots) ?? BotsState()
  case let action as GetPush:
    if let bot = action.payload.bot {
      return state?.upsert(bots: [bot]) ?? BotsState()
    }
    return state ?? BotsState()
  case let action as GetPlugin:
    if let bot = action.bot {
      return state?.upsert(bots: [bot]) ?? BotsState()
    }
    return state ?? BotsState()
  case _ as CheckOutSuccess:
    return state?.clear() ?? BotsState()
  default:
    return state ?? BotsState()
  }
}
