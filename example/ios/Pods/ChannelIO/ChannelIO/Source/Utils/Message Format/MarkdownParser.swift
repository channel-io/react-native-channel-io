//
//  MarkdownParser.swift
//  Pods
//
//  Created by Ivan Bruel on 18/07/16.
//
//

import UIKit

open class MarkdownParser {

  // MARK: Element Arrays
  fileprivate var escapingElements: [MarkdownElement]
  fileprivate var defaultElements: [MarkdownElement]
  fileprivate var unescapingElements: [MarkdownElement]

  public var customElements: [MarkdownElement]

  // MARK: Basic Elements
  public let quote: MarkdownQuote
  public let link: MarkdownLink
  public let automaticLink: MarkdownAutomaticLink
  public let bold: MarkdownBold
  public let italic: MarkdownItalic
  public let boldItalic: MarkdownBoldItalic
  public let header: MarkdownHeader
  public let code: MarkdownCode
  public let emoji: MarkdownEmoji
  public let mention: MarkdownMention
  
  // MARK: Escaping Elements
  fileprivate var codeEscaping = MarkdownCodeEscaping()
  fileprivate var escaping = MarkdownEscaping()
  fileprivate var unescaping = MarkdownUnescaping()

  // MARK: Configuration
  /// Enables or disables detection of URLs even without Markdown format
  public var automaticLinkDetectionEnabled: Bool = true
  public let font: UIFont
  let emojiFont: UIFont = UIFont.systemFont(ofSize: 40)
  
  // MARK: Initializer
  public init(font: UIFont = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
              automaticLinkDetectionEnabled: Bool = true,
              customElements: [MarkdownElement] = []) {
    self.font = font

    quote = MarkdownQuote(font: font)
    link = MarkdownLink(font: font)
    automaticLink = MarkdownAutomaticLink(font: font)
    bold = MarkdownBold(font: font)
    boldItalic = MarkdownBoldItalic(font: font)
    italic = MarkdownItalic(font: font)
    header = MarkdownHeader(font: font, maxLevel: 5, fontIncrease: 2, color: CHColors.dark)
    code = MarkdownCode(font: font)
    emoji = MarkdownEmoji(font: font, map: CHUtils.emojiMap())
    mention = MarkdownMention(font: font)
    
    self.automaticLinkDetectionEnabled = automaticLinkDetectionEnabled
    self.escapingElements = [escaping] //[codeEscaping, escaping]
    self.defaultElements = [quote, link, automaticLink, boldItalic, bold, italic, mention, emoji]
    self.unescapingElements = [unescaping] //[code, unescaping]
    self.customElements = customElements
  }

  // MARK: Element Extensibility
  open func addCustomElement(_ element: MarkdownElement) {
    customElements.append(element)
  }

  open func removeCustomElement(_ element: MarkdownElement) {
    guard let index = customElements.index(where: { someElement -> Bool in
      return element === someElement
    }) else {
      return
    }
    customElements.remove(at: index)
  }

  // MARK: Parsing
  open func parse(_ markdown: String) -> (NSAttributedString?, Bool) {
    let tokens = markdown.components(separatedBy: "```")
    let attributedString = NSMutableAttributedString(string: markdown)

    var location = 0
    for (index, token) in tokens.enumerated() {
      var range = NSRange(location: location, length: token.utf16.count)
      if index % 2 != 1 && token != "" {
        let parsed = parse(NSAttributedString(string: token))
        attributedString.replaceCharacters(in: range, with: parsed)
        location += parsed.length
      } else if index % 2 == 1 && (index != tokens.count - 1) {
        let startPart = NSRange(location: range.location, length: 3)
        let endPart = NSRange(location: range.location + token.count + 3, length: 3)
        attributedString.deleteCharacters(in: endPart)
        attributedString.deleteCharacters(in: startPart)
        attributedString.addAttributes([NSAttributedStringKey.font: self.font], range: range)
        location += range.length
      } else if index == tokens.count - 1 && token != "" {
        let parsed = parse(NSAttributedString(string: token))
        range.location += 3
        attributedString.replaceCharacters(in: range, with: parsed)
        location += parsed.length
      }
    }

    let onlyEmoji = attributedString.string.containsOnlyEmoji
    if onlyEmoji {
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .left
      paragraphStyle.minimumLineHeight = 20
      attributedString.addAttributes(
        [NSAttributedStringKey.font: self.emojiFont, NSAttributedStringKey.paragraphStyle:paragraphStyle],
        range: NSRange(location: 0, length: attributedString.length))
    }
    
    return (attributedString, onlyEmoji)
  }

  open func parse(_ markdown: NSAttributedString) -> NSAttributedString {
    let attributedString = NSMutableAttributedString(attributedString: markdown)

    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineBreakMode = attributedString.string.guessLanguage() == "日本語" ? .byCharWrapping : .byWordWrapping
    paragraphStyle.alignment = .left
    paragraphStyle.minimumLineHeight = 20
    
    attributedString.addAttributes(
      [NSAttributedStringKey.font: self.font, NSAttributedStringKey.paragraphStyle:paragraphStyle],
      range: NSRange(location: 0, length: attributedString.length))
    
    var elements: [MarkdownElement] = escapingElements
    elements.append(contentsOf: defaultElements)
    elements.append(contentsOf: customElements)
    elements.append(contentsOf: unescapingElements)
    elements.forEach { element in
      if automaticLinkDetectionEnabled || type(of: element) != MarkdownAutomaticLink.self {
        element.parse(attributedString)
      }
    }
    return attributedString
  }

}
