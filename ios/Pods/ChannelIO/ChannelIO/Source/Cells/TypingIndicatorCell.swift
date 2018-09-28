//
//  TypingIndicatorCell.swift
// 
//
//  Created by R3alFr3e on 11/14/17.
//

import Foundation
import UIKit
import SnapKit
import Reusable

final class TypingIndicatorCell: BaseTableViewCell, Reusable {  
  let multiAvatarView = LiveTypingAvatarsView(avatarSize: 22, coverMargin: 4)
  
  let personCountLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 12)
    $0.textColor = CHColors.blueyGrey
  }
  let typingImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  var avatarViewWidthConstraint: Constraint? = nil
  
  override func initialize() {
    super.initialize()
    
    if let data = CHAssets.getData(named: "typing", type: "gif") {
      self.typingImageView.image = UIImage.sd_animatedGIF(with: data)
    }
    
    self.backgroundColor = UIColor.clear
    self.contentView.addSubview(self.multiAvatarView)
    self.contentView.addSubview(self.personCountLabel)
    self.contentView.addSubview(self.typingImageView)
  }
  
  override func prepareForReuse() {
    self.typingImageView.layoutIfNeeded()
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.multiAvatarView.snp.makeConstraints { (make) in
      make.leading.equalToSuperview().inset(10)
      make.height.equalTo(22)
      make.centerY.equalToSuperview()
    }
    
    self.personCountLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalTo((self?.multiAvatarView.snp.trailing)!).offset(2)
      make.centerY.equalToSuperview()
    }
    
    self.typingImageView.snp.makeConstraints { [weak self] (make) in
      make.centerY.equalToSuperview()
      make.height.equalTo(6)
      make.width.equalTo(22)
      make.leading.equalTo((self?.personCountLabel.snp.trailing)!).offset(6)
    }
  }
  
  func configure(typingUsers: [CHEntity]) {
    guard typingUsers.count > 0 else {
      self.multiAvatarView.isHidden = true
      self.typingImageView.isHidden = true
      self.personCountLabel.isHidden = true
      return
    }
    
    self.typingImageView.isHidden = false
    self.multiAvatarView.isHidden = false
    UIView.animate(withDuration: 0.2) {
      self.personCountLabel.isHidden = typingUsers.count < 4
      self.personCountLabel.text = typingUsers.count < 4 ? "" : "+\(typingUsers.count)"
    }
    
    self.multiAvatarView.configure(persons: typingUsers)
  }
}

