//
//  UIView+RoundCorners.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 22..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

extension UIView {
  func roundCorners(corners: UIRectCorner, radius: CGFloat) {
    self.layer.setNeedsLayout()
    self.layer.layoutIfNeeded()
    
    let rectShape = CAShapeLayer()
    rectShape.bounds = self.frame
    rectShape.position = self.center
    rectShape.path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius)).cgPath
    self.layer.mask = rectShape
  }
}

extension UIView {
  @discardableResult func addBorders(edges: UIRectEdge, color: UIColor = .black, thickness: CGFloat = 1.0) -> [UIView] {
    var borders = [UIView]()
    
    func border() -> UIView {
      let border = UIView(frame: CGRect.zero)
      border.backgroundColor = color
      border.translatesAutoresizingMaskIntoConstraints = false
      return border
    }
    
    if edges.contains(.top) || edges.contains(.all) {
      let top = border()
      addSubview(top)
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",
                                       options: [],
                                       metrics: ["thickness": thickness],
                                       views: ["top": top]))
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",
                                       options: [],
                                       metrics: nil,
                                       views: ["top": top]))
      borders.append(top)
    }
    
    if edges.contains(.left) || edges.contains(.all) {
      let left = border()
      addSubview(left)
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",
                                       options: [],
                                       metrics: ["thickness": thickness],
                                       views: ["left": left]))
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",
                                       options: [],
                                       metrics: nil,
                                       views: ["left": left]))
      borders.append(left)
    }
    
    if edges.contains(.right) || edges.contains(.all) {
      let right = border()
      addSubview(right)
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",
                                       options: [],
                                       metrics: ["thickness": thickness],
                                       views: ["right": right]))
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",
                                       options: [],
                                       metrics: nil,
                                       views: ["right": right]))
      borders.append(right)
    }
    
    if edges.contains(.bottom) || edges.contains(.all) {
      let bottom = border()
      addSubview(bottom)
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",
                                       options: [],
                                       metrics: ["thickness": thickness],
                                       views: ["bottom": bottom]))
      addConstraints(
        NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[bottom]-(0)-|",
                                       options: [],
                                       metrics: nil,
                                       views: ["bottom": bottom]))
      borders.append(bottom)
    }
    return borders
  }
}
