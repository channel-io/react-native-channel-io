//
//  Badge.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 7..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import SnapKit

final class Badge: NeverClearView {

  // MARK: Constants

  struct Metric {
    static let minWidth = 12.f // TODO: Expose to outside
    static let padding = 6.f // TODO: Expose to outside
  }

  struct Font {
    static let text = UIFont.boldSystemFont(ofSize: 13)
  }

  struct Color {
    static let text = CHColors.white
    static let background = CHColors.warmPink
  }

  // MARK: Properties

  let label = UILabel().then {
    $0.font = Font.text
    $0.textColor = Color.text
    $0.textAlignment = .center
  }

  // MARK: Initializing

  override func initialize() {
    super.initialize()
    self.clipsToBounds = true
    self.backgroundColor = Color.background
    self.addSubview(self.label)
  }

  // MARK: Configuring

  func configure(_ badgeCount: Int) {
    if badgeCount > 99 {
      self.label.text = "99+"
    } else {
      self.label.text = "\(badgeCount)"
    }
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    self.layer.cornerRadius = self.height / 2

    self.label.snp.remakeConstraints { (make) in
      make.width.greaterThanOrEqualTo(Metric.minWidth)
      make.leading.equalToSuperview().inset(5)
      make.trailing.equalToSuperview().inset(5)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }

  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let labelSize = self.label.sizeThatFits(size)
    return CGSize(width: max(labelSize.width + Metric.padding * 2, Metric.minWidth), height: size.height)
  }
}
