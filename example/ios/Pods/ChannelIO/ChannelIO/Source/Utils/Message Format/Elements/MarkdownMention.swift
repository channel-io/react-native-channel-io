//
//  MarkdownMention.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 26/02/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit

open class MarkdownMention: MarkdownCommonElement, MarkdownCommonLexElement {  
  fileprivate static let regex = "(?:<@([^<>]+)>)"
  fileprivate static let lexRegex = "(?<!@[^\\s<>]+)"
  
  open var font: UIFont?
  open var color: UIColor?
  open var regex: String {
    return MarkdownMention.regex
  }
  open var lexRegex: String {
    return MarkdownMention.lexRegex
  }
  var map = [String: String]()
  
  public init(font: UIFont? = nil, color: UIColor? = nil) {
    self.font = font
    self.color = color
  }
  
  //MARK - parser
  
  open func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString) {
    let nsString = attributedString.string as NSString
    let mentionStartResult = nsString.range(of: "<", options: .backwards, range: match.range).location
    let mentionEndLocation = nsString.range(of: ">", options: .backwards, range: match.range).location
    var mentionRange = NSRange(location: mentionStartResult + 2,
                            length: match.range.length + match.range.location - mentionStartResult - 3)
    let idLocation = nsString.range(of: ":", options: .backwards, range: mentionRange).location
    let mention = nsString.substring(with: mentionRange)
    
    attributedString.deleteCharacters(in: NSRange(location: match.range.location + match.range.length - 1, length: 1))
    if idLocation >= 0 && idLocation < (match.range.location + match.range.length) {
      //remove :*
      attributedString.deleteCharacters(in: NSRange(location: idLocation, length: mentionEndLocation - idLocation))
      mentionRange = NSRange(location: mentionStartResult, length: idLocation - mentionStartResult - 1)
    } else {
      mentionRange = NSRange(location: match.range.location, length: mention.count + 1)
    }
    attributedString.deleteCharacters(in: NSRange(location: match.range.location, length: 1))
    
    formatText(attributedString, range: mentionRange, link: "mention://\(mention)")
    addAttributes(attributedString, range: mentionRange)
  }
  
  open func formatText(_ attributedString: NSMutableAttributedString, range: NSRange, link: String) {
    guard let encodedLink = link.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed) else {
        return
    }
    
    guard let url = URL(string: link) ?? URL(string: encodedLink) else { return }
    attributedString.addAttribute(NSAttributedStringKey.link, value: url, range: range)
  }
  
  open func addAttributes(_ attributedString: NSMutableAttributedString, range: NSRange) {
    attributedString.addAttributes(attributes, range: range)
  }
  
  //MARK - lexer
  
  func addIdMaps(_ map: [String: String]) {
    self.map = map
  }
  
  open func match(_ match: NSTextCheckingResult, string: String) -> String {
    let nsString = NSMutableString(string: string)
    let matchName = nsString.substring(with: NSRange(location: match.range.location + 1, length: match.range.length - 1))
    
    nsString.insert("<", at: match.range.location)
    if let id = self.map[matchName] {
      nsString.insert(":\(id)>", at: match.range.location + match.range.length + 1)
    } else {
      nsString.insert(">", at: match.range.location + match.range.length + 1)
    }
    
    return nsString as String
  }
}
