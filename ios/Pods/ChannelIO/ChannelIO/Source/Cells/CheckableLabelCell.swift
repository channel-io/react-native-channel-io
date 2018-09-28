//
//  CheckableLabelCell.swift
//  ChannelIO
//
//  Created by Haeun Chung on 09/04/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import SnapKit
import Reusable

final class CheckableLabelCell : BaseTableViewCell, Reusable {
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 16)
    $0.textColor = CHColors.dark
    $0.numberOfLines = 1
  }
  
  let checkImageView = UIImageView().then {
    $0.contentMode = .center
    $0.image = CHAssets.getImage(named: "checkBlue")
    $0.isHidden = true
  }
  
  var checked = false {
    didSet {
      self.titleLabel.textColor = self.checked ?
        CHColors.dark : CHColors.blueyGrey60
      self.checkImageView.isHidden = !self.checked
    }
  }
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.titleLabel)
    self.addSubview(self.checkImageView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.titleLabel.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().inset(16)
    }
    
    self.checkImageView.snp.remakeConstraints { (make) in
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(10)
    }
  }
  
  class func height() -> CGFloat {
    return 52
  }
}
