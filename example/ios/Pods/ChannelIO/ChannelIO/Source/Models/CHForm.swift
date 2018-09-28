//
//  CHForm.swift
//  ChannelIO
//
//  Created by Haeun Chung on 08/06/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

enum FormOptionKey: String {
  case disableToManager
}

enum FormType : String {
  case select
  case button
  case solve = "userChat.solve"
  case close = "userChat.close"
}

struct CHForm {
  var type: FormType = .select
  var inputs: [CHInput] = []
  var closed: Bool = false
  var option: [FormOptionKey: Bool] = [:]
}

extension CHForm: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    type        <- map["type"]
    inputs      <- map["inputs"]
    option      <- map["option"]
    closed      <- map["closed"]
  }
}

struct CHInput {
  var key: String = ""
  var text: NSAttributedString? = nil
  
  var onlyEmoji: Bool = false
}

extension CHInput: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    key         <- map["key"]
    let rawText = map["text"].currentValue as? String ?? ""
    (text, onlyEmoji) = CustomMessageTransform.markdown.parse(rawText)
  }
}

struct CHSubmit {
  var id: String = ""
  var key: String = ""
}

extension CHSubmit: Mappable {
  init?(map: Map) { }
  
  mutating func mapping(map: Map) {
    id        <- map["id"]
    key       <- map["key"]
  }
}
