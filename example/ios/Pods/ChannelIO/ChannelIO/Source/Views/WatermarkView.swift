//
//  WatermarkView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 08/01/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit

class WatermarkView : BaseView {
  let contentView = UIView()
  let brandImageview = UIImageView().then {
    $0.image = CHAssets.getImage(named: "chSymbol")
    $0.contentMode = .scaleToFill
  }
  
  let descLabel = UILabel().then {
    let channelStr = CHAssets.localized("ch.channel_io")
    let watermarkStr = CHAssets.localized("ch.watermark") as NSString
    let attributedString = NSMutableAttributedString(string: watermarkStr as String)
    attributedString.addAttribute(
      NSAttributedStringKey.font, value: UIFont.systemFont(ofSize: 11),
      range: NSRange(location: 0, length: watermarkStr.length))
    attributedString.addAttribute(
      NSAttributedStringKey.foregroundColor, value: CHColors.blueyGrey,
      range: NSRange(location: 0, length: watermarkStr.length))
    attributedString.addAttribute(
      NSAttributedStringKey.font, value: UIFont.boldSystemFont(ofSize: 11),
      range: watermarkStr.range(of: channelStr))
    $0.attributedText = attributedString
    $0.textColor = CHColors.blueyGrey
  }
  
  override func initialize() {
    super.initialize()
    self.backgroundColor = UIColor.clear
    self.contentView.backgroundColor = UIColor.clear
    
    self.contentView.addSubview(self.brandImageview)
    self.contentView.addSubview(self.descLabel)
    self.addSubview(self.contentView)
  }
  
  override func setLayouts() {
    super.setLayouts()
        
    self.contentView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.centerX.equalToSuperview()
    }
    
    self.brandImageview.snp.makeConstraints { (make) in
      make.leading.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.descLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalTo((self?.brandImageview.snp.trailing)!).offset(5)
      make.trailing.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
}
