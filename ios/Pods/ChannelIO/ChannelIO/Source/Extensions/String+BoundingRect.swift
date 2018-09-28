//
//  String+BoundingRect.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 15..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

extension String {
  func boundingRect(with size: CGSize, attributes: [NSAttributedStringKey: Any]) -> CGRect {
    let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]
    let rect = self.boundingRect(with: size, options: options, attributes: attributes, context: nil)
    return snap(rect)
  }

  func size(fits size: CGSize, font: UIFont, maximumNumberOfLines: Int = 0) -> CGSize {
    let attributes = [NSAttributedStringKey.font: font]
    var size = self.boundingRect(with: size, attributes: attributes).size
    if maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    return size
  }

  func width(with font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).width
  }

  func height(fits width: CGFloat, font: UIFont, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, font: font, maximumNumberOfLines: maximumNumberOfLines).height
  }
  
  func height(fits width: CGFloat, attributes: [NSAttributedStringKey:Any]) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.boundingRect(with: size, attributes: attributes).height
  }
}

extension NSAttributedString {
  func boundingRect(fits size: CGSize) -> CGRect {
    let rect = self.boundingRect(with: size, options: [.usesFontLeading, .usesLineFragmentOrigin], context: nil)
    return snap(rect)
  }
  
  func size(fits size: CGSize, maximumNumberOfLines: Int = 0) -> CGSize {
    if self.string == "" {
      return CGSize.zero
    }
    
    var size = self.boundingRect(fits: size).size
    let attributes = self.attributes(at: 0, effectiveRange: nil)
   
    if let font = attributes[NSAttributedStringKey.font] as? UIFont, maximumNumberOfLines > 0 {
      size.height = min(size.height, CGFloat(maximumNumberOfLines) * font.lineHeight)
    }
    
    return size
  }
  
  func height(fits width: CGFloat, maximumNumberOfLines: Int = 0) -> CGFloat {
    let size = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return self.size(fits: size, maximumNumberOfLines: maximumNumberOfLines).height
  }
}

func snap(_ x: CGFloat) -> CGFloat {
  let scale = UIScreen.main.scale
  return ceil(x * scale) / scale
}

func snap(_ point: CGPoint) -> CGPoint {
  return CGPoint(x: snap(point.x), y: snap(point.y))
}

func snap(_ size: CGSize) -> CGSize {
  return CGSize(width: snap(size.width), height: snap(size.height))
}

func snap(_ rect: CGRect) -> CGRect {
  return CGRect(origin: snap(rect.origin), size: snap(rect.size))
}
