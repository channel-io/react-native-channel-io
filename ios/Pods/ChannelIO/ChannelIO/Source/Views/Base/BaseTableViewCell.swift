//
//  BaseTableViewCell.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import MGSwipeTableCell
import RxSwift

class BaseTableViewCell: MGSwipeTableCell {

  // MARK: Initializing
  var disposeBag = DisposeBag()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.initialize()
    self.setLayouts()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: overridable
  
  func initialize() {

  }
  
  func setLayouts() {
    
  }
}
