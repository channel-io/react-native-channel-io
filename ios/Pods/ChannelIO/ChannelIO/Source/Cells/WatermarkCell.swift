//
//  WatermarkCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 08/01/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Reusable

class WatermarkCell : BaseTableViewCell, Reusable {
  let watermarkView = WatermarkView()
  
  override func initialize() {
    super.initialize()
    
    self.contentView.addSubview(self.watermarkView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.watermarkView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
}
