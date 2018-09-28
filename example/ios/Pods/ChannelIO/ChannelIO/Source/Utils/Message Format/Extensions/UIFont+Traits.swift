//
//  UIFont+Traits.swift
//  Pods
//
//  Created by Ivan Bruel on 19/07/16.
//
//
import UIKit

extension UIFont {

  func withTraits(_ traits: UIFontDescriptorSymbolicTraits...) -> UIFont {
    let descriptor = fontDescriptor
      .withSymbolicTraits(UIFontDescriptorSymbolicTraits(traits))
    return UIFont(descriptor: descriptor!, size: 0)
  }

  func bold() -> UIFont {
    return withTraits(.traitBold)
  }

  func italic() -> UIFont {
    let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(15 * CGFloat.pi / 180))), d: 1, tx: 0, ty: 0)
    let descriptor = UIFontDescriptor.init(name: "Helvetica", matrix: matrix)
    return UIFont(descriptor: descriptor, size: 15)
  }
  
  func boldItalic() -> UIFont {
    let matrix = CGAffineTransform(a: 1, b: 0, c: CGFloat(tanf(Float(15 * CGFloat.pi / 180))), d: 1, tx: 0, ty: 0)
    let descriptor = UIFontDescriptor.init(name: "Helvetica-Bold", matrix: matrix)
    return UIFont(descriptor: descriptor, size: 15)
  }
}
