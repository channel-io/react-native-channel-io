//
//  TextInputCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 18/05/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SnapKit

final class TextInputCell: BaseTableViewCell {
  
  let textField = UITextField().then {
    $0.font = UIFont.systemFont(ofSize: 16, weight: UIFont.Weight.medium)
    $0.textColor = CHColors.dark
  }
  
  let editImageView = UIImageView().then {
    $0.contentMode = .center
    $0.image = CHAssets.getImage(named: "edit")
  }
  
  var isEditable = true {
    didSet {
      self.editImageView.isHidden = !self.isEditable
      self.contentView.isUserInteractionEnabled = self.isEditable
    }
  }
  
  override func initialize() {
    super.initialize()
    
    self.contentView.addSubview(self.textField)
    self.contentView.addSubview(self.editImageView)
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.textField.snp.remakeConstraints { [weak self] (make) in
      make.leading.equalToSuperview().inset(16)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalTo((self?.editImageView.snp.leading)!).offset(10)
    }
    
    self.editImageView.snp.remakeConstraints { (make) in
      make.trailing.equalToSuperview().inset(14)
      make.centerY.equalToSuperview()
      make.size.equalTo(CGSize(width: 24, height: 24))
    }
  }
  
  func configure(placeholder: String) {
    self.textField.placeholder = placeholder
  }
  
  class func height() -> CGFloat {
    return 48
  }
}
