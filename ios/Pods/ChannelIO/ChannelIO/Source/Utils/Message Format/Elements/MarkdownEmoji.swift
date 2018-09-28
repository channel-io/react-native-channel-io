//
//  MarkdownEmoji.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 26/02/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit

open class MarkdownEmoji: MarkdownCommonElement {
  
  fileprivate static let regex = "(:)([a-zA-Z0-9_+-]+)(\\1)"
  
  open var font: UIFont?
  open var color: UIColor?
  open var emojiMap: [String:String] = [:]
  open var regex: String {
    return MarkdownEmoji.regex
  }
  
  public init(font: UIFont? = nil, color: UIColor? = nil, map: [String: String]) {
    self.font = font
    self.color = color
    self.emojiMap = map
  }
  
  open func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
    let keyRange = NSRange(location: match.range.location + 1, length: match.range.length - 2)
    let matchString = attributedString.attributedSubstring(from: keyRange).string
    guard let emoji = self.emojiMap[matchString] else { return }
    attributedString.replaceCharacters(in: match.range, with: emoji)
    attributedString.addAttributes(attributes, range: NSRange(location: match.range.location, length: emoji.count))
  }
  
//  open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
//    let matchString: String = attributedString.attributedSubstring(from: range).string
//    //replace emoji here
//    //guard let unescapedString = matchString.unescapeUTF16() else { return }
//    guard let emoji = self.emojiMap[matchString] else { return }
//    attributedString.replaceCharacters(in: range, with: emoji)
//    attributedString.addAttributes(attributes, range: NSRange(location: range.location, length: emoji.count))
//  }
}
