//
//  MultiAvatarView.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 7..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import SnapKit

final class MultiAvatarView: NeverClearView {

  // MARK: Constants

  // MARK: Properties

  var avatarViews = [
    AvatarView(),
    AvatarView(),
    AvatarView()
  ]

  // MARK: Initializing

  override func initialize() {
    super.initialize()
    self.avatarViews.forEach({ self.addSubview($0) })
  }

  // MARK: Configuring

  func configure(_ avatars: [CHEntity]) {
    for (index, element) in self.avatarViews.enumerated() {
      if index < avatars.count {
        element.configure(avatars[index])
        element.isHidden = false
      } else {
        element.isHidden = true
      }
    }
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()
    if self.avatarViews[1].isHidden {
      self.layoutOneAvatar()
    } else if self.avatarViews[2].isHidden {
      self.layoutTwoAvatar()
    } else {
      self.layoutThreeAvatar()
    }
  }

  private func layoutOneAvatar() {
    self.avatarViews[0].showBorder = false
    self.avatarViews[0].top = 0
    self.avatarViews[0].left = 0
    self.avatarViews[0].width = self.width
    self.avatarViews[0].height = self.height
  }

  private func layoutTwoAvatar() {
    let width = self.width * 0.77

    self.avatarViews[0].showBorder = true
    self.avatarViews[0].top = 0
    self.avatarViews[0].left = 0
    self.avatarViews[0].width = width
    self.avatarViews[0].height = width

    self.avatarViews[1].top = self.width - width
    self.avatarViews[1].left = self.width - width
    self.avatarViews[1].width = width
    self.avatarViews[1].height = width
  }

  private func layoutThreeAvatar() {
    let width = self.width * 0.55

    self.avatarViews[0].showBorder = true
    self.avatarViews[0].top = 0
    self.avatarViews[0].left = 0
    self.avatarViews[0].width = width
    self.avatarViews[0].height = width

    self.avatarViews[1].showBorder = true
    self.avatarViews[1].width = width
    self.avatarViews[1].height = width
    self.avatarViews[1].top = (self.height - self.avatarViews[1].height)/2
    self.avatarViews[1].left = self.width - width

    self.avatarViews[2].showBorder = true
    self.avatarViews[2].top = self.height - width
    self.avatarViews[2].left = 0
    self.avatarViews[2].width = width
    self.avatarViews[2].height = width
  }
}

