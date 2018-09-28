//
//  LabelCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 18/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SnapKit
import Reusable

final class LabelCell : BaseTableViewCell, Reusable {
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 16)
    $0.textColor = CHColors.dark
    $0.numberOfLines = 1
  }
  
  let arrowImageView = UIImageView().then {
    $0.contentMode = .center
    $0.image = CHAssets.getImage(named: "chevronRightSmall")
    $0.isHidden = true
  }
  
  var disabled = false {
    didSet {
      self.titleLabel.textColor = self.disabled ?
        CHColors.blueyGrey60 : CHColors.dark
    }
  }
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.titleLabel)
    self.addSubview(self.arrowImageView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.titleLabel.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }
    
    self.arrowImageView.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(10)
    }
  }
  
  class func height() -> CGFloat {
    return 52
  }
}
