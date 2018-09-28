//
//  ChatBannerView.swift
//  ch-desk-ios
//
//  Created by Haeun Chung on 06/07/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

final class NewMessageBannerView : BaseView {
  
  let avatarView = AvatarView().then {
    $0.showBorder = false
  }
  
  let newMessageLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.textColor = CHColors.cobalt
    $0.numberOfLines = 1
    $0.text = CHAssets.localized("ch.chat.new_message")
  }
  
  override func initialize() {
    super.initialize()

    self.backgroundColor = UIColor.white
    
    self.layer.cornerRadius = 24.f
    self.layer.shadowColor = CHColors.dark.cgColor
    self.layer.shadowOffset = CGSize(width: 0.f, height: 3.f)
    self.layer.shadowRadius = 3.f
    self.layer.shadowOpacity = 0.3
    
    self.addSubview(self.avatarView)
    self.addSubview(self.newMessageLabel)
  }
  
  func configure(message: CHMessage) {
    if let user = message.entity {
      self.avatarView.configure(user)
    }
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.avatarView.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(10)
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
    
    self.newMessageLabel.snp.remakeConstraints { [weak self] (make) in
      make.centerY.equalToSuperview()
      make.leading.equalTo((self?.avatarView.snp.trailing)!).offset(12)
      make.trailing.equalToSuperview().inset(20)
    }
  }
}
