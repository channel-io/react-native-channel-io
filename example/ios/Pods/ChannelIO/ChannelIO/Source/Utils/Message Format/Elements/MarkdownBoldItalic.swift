//
//  MarkdownBoldItalic.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 26/02/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import UIKit

open class MarkdownBoldItalic: MarkdownCommonElement {
  
  fileprivate static let regex = "(\\s*|^)(\\*\\*\\*)(.+?)(\\2)"
  
  open var font: UIFont?
  open var color: UIColor?
  
  open var regex: String {
    return MarkdownBoldItalic.regex
  }
  
  public init(font: UIFont? = nil, color: UIColor? = nil) {
    self.font = font?.boldItalic()
    self.color = color
  }
}
