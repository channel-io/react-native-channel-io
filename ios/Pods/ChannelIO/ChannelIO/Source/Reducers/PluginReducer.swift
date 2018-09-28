//
//  PluginReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func pluginReducer(action: Action, plugin: CHPlugin?) -> CHPlugin {
  switch action {
  case let action as GetPlugin:
    return action.plugin 
  case let action as CheckInSuccess:
    return (action.payload["plugin"] as? CHPlugin) ?? CHPlugin()
  case _ as CheckOutSuccess:
    return CHPlugin()
  default:
    return plugin ?? CHPlugin()
  }
}
