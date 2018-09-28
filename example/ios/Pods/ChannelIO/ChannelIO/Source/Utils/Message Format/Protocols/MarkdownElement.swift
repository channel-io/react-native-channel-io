//
//  MarkdownElement.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//

import Foundation

/// The base protocol for all Markdown Elements, it handles parsing through regex.
public protocol MarkdownElement: class {
  var regex: String { get }
  
  func regularExpression() throws -> NSRegularExpression
  func parse(_ attributedString: NSMutableAttributedString)
  func match(_ match: NSTextCheckingResult, attributedString: NSMutableAttributedString)
}

public protocol MarkdownLexElement: class {
  var lexRegex: String { get }
  
  func regularLexExpression() throws -> NSRegularExpression
  func lexer(_ string: String) -> String
  func match(_ match: NSTextCheckingResult, string: String) -> String
}

public extension MarkdownElement {
  func parse(_ attributedString: NSMutableAttributedString) {
      var location = 0
      do {
        let regex = try regularExpression()
        while let regexMatch =
          regex.firstMatch(in: attributedString.string,
           options: .withoutAnchoringBounds,
           range: NSRange(location: location,
          length: attributedString.length - location)) {
          let oldLength = attributedString.length
          match(regexMatch, attributedString: attributedString)
          let newLength = attributedString.length
          location = regexMatch.range.location + regexMatch.range.length + newLength - oldLength
        }
      } catch { }
  }
}

public extension MarkdownLexElement {
  func lexer(_ string: String) -> String {
    var string = string
    var location = 0
    do {
      let regex = try regularLexExpression()
      while let regexMatch = regex.firstMatch(in: string,
        options: .withoutAnchoringBounds,
        range: NSRange(location: location, length: string.count - location)) {
        
        let oldLength = string.count
        string = match(regexMatch, string: string)
        let newLength = string.count
        location = regexMatch.range.location + regexMatch.range.length + newLength - oldLength
      }
    } catch { }
    return string
  }
}

