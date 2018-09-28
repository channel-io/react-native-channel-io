//
//  CustomDateTransform.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

class CustomDateTransform: TransformType {
  public typealias Object = Date
  public typealias JSON = Double

  public init() {}
  
  open func transformFromJSON(_ value: Any?) -> Date? {
    if let timeInt = value as? Double {
      return Date(timeIntervalSince1970: TimeInterval(timeInt / 1000))
    }

    return nil
  }

  open func transformToJSON(_ value: Date?) -> Double? {
    if let date = value {
      return Double(date.timeIntervalSince1970 * 1000)
    }
    return nil
  }
}

struct StringTransform: TransformType {
  func transformFromJSON(_ value: Any?) -> String? {
    return value.flatMap(String.init(describing:))
  }
  
  func transformToJSON(_ value: String?) -> Any? {
    return value
  }
}

struct CustomMessageTransform: TransformType {
  static var markdown = MarkdownParser(font: UIFont.systemFont(ofSize: 15))
  
  func transformFromJSON(_ value: Any?) -> NSAttributedString? {
    if let message = value as? String {
      let parsed = CustomMessageTransform.markdown.parse(message)
      return parsed.0
    }
    return nil
  }
  
  func transformToJSON(_ value: NSAttributedString?) -> String? {
    return value?.string ?? ""
  }
}
