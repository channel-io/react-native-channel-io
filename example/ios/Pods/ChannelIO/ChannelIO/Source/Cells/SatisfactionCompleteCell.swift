//
//  SatisfactionCompleteCell.swift
//  CHPlugin
//
//  Created by R3alFr3e on 6/20/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SnapKit
import Reusable

final class SatisfactionCompleteCell: BaseTableViewCell, Reusable {
  let containerView = UIView()
  
  let iconView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
  }
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.textColor = CHColors.dark
    $0.textAlignment = .center
  }
  
  static var reuseIdentifier = "SatisfactionCompleteCell"
  
  override func initialize() {
    super.initialize()
    
    self.containerView.layer.cornerRadius = 6
    self.containerView.layer.shadowColor = CHColors.dark.cgColor
    self.containerView.layer.shadowOpacity = 0.2
    self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.containerView.layer.shadowRadius = 3
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = CHColors.lightGray.cgColor
    self.containerView.backgroundColor = CHColors.white

    self.containerView.addSubview(self.iconView)
    self.containerView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.containerView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.containerView.snp.remakeConstraints { (make) in
      make.top.equalToSuperview().inset(8)
      make.leading.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
      make.bottom.equalToSuperview().inset(8)
    }
    
    self.iconView.snp.remakeConstraints { (make) in
      make.size.equalTo(CGSize(width: 36, height: 36))
      make.top.equalToSuperview().inset(18)
      make.centerX.equalToSuperview()
    }
    
    self.titleLabel.snp.remakeConstraints { [weak self] (make) in
      make.leading.equalToSuperview().inset(20)
      make.trailing.equalToSuperview().inset(20)
      make.top.equalTo((self?.iconView.snp.bottom)!).offset(14)
    }
  }
  
  func configure(review: String?, duration: Int?) {
    if let review = review {
      if review == "" {
        self.iconView.image = CHAssets.getImage(named: "neutralFace")
      } else if review == "like" {
        self.iconView.image = CHAssets.getImage(named: "happyFaceLarge")
      } else if review == "dislike" {
        self.iconView.image = CHAssets.getImage(named: "angryFaceLarge")
      }
      
      if review == "" {
        self.titleLabel.text = CHAssets.localized("ch.review.cancel")
      } else {
        self.titleLabel.text = CHAssets.localized("ch.review.complete.preview")
      }
    }
  }
  
  class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    return 104 + 16
  }
}
