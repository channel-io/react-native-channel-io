//
//  Plugin.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import RxSwift
import Foundation
import ObjectMapper

struct CHPlugin: ModelType {
  var id = ""
  var color = ""
  var borderColor = ""
  var textColor = ""
  var mobileMarginX = 0
  var mobileMarginY = 0
  var mobileHideButton = false
  var botName = ""
  
  var mobilePosition = "right"
  var welcomeNamedI18n: CHi18n?
  var welcomeI18n: CHi18n?
  
  var textUIColor: UIColor! {
    if self.textColor == "white" {
      return CHColors.white
    } else {
      return CHColors.black
    }
  }
}

extension CHPlugin: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id               <- map["id"]
    color            <- map["color"]
    borderColor      <- map["borderColor"]
    textColor        <- map["textColor"]
    mobileMarginX    <- map["mobileMarginX"]
    mobileMarginY    <- map["mobileMarginY"]
    mobileHideButton <- map["mobileHideButton"]
    botName          <- map["botName"]
    welcomeNamedI18n <- map["welcomeNamedI18n"]
    welcomeI18n      <- map["welcomeI18n"]
  }
}

extension CHPlugin {
  static func get(with id: String) -> Observable<(CHPlugin, CHBot?)> {
    return PluginPromise.getPlugin(pluginId: id)
  }
}
