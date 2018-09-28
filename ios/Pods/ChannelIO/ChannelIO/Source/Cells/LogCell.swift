//
//  LogCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 27/06/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import Reusable

final class LogCell : BaseTableViewCell, Reusable {
  let container = UIView().then {
    $0.backgroundColor = CHColors.paleGrey
  }
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.textColor = CHColors.dark
    $0.textAlignment = .center
  }
  
  let timestampLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 11)
    $0.textColor = CHColors.blueyGrey
    $0.textAlignment = .left
  }
  
  override func initialize() {
    super.initialize()
    
    self.container.addSubview(self.titleLabel)
    self.container.addSubview(self.timestampLabel)
    self.contentView.addSubview(self.container)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.container.snp.remakeConstraints { (make) in
      make.edges.equalToSuperview().inset(UIEdgeInsetsMake(6, 0, 6, 0))
    }
    
    self.titleLabel.snp.remakeConstraints { (make) in
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview().inset(10)
    }
    
    self.timestampLabel.snp.remakeConstraints { [weak self] (make) in
      make.trailing.greaterThanOrEqualToSuperview().inset(10)
      make.centerY.equalToSuperview()
      make.leading.equalTo((self?.titleLabel.snp.trailing)!).offset(5)
    }
  }
  
  func configure(message: CHMessage) {
    guard let log = message.log else { return }
    if log.action == "closed" {
      self.titleLabel.text = CHAssets.localized("ch.log.closed")
      self.timestampLabel.text = message.createdAt.readableShortString()
    }
    
    self.setNeedsLayout()
    self.layoutIfNeeded()
  }
  
  class func cellHeight(fit width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    return 46
  }
}
