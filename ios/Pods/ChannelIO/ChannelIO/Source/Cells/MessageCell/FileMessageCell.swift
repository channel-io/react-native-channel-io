//
//  FileMessageCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 26/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class FileMessageCell: MessageCell {
  let fileView = FileMessageView().then {
    $0.backgroundColor = UIColor.white
  }
  
  var rightConstraint: Constraint? = nil
  var leftConstraint: Constraint? = nil
  
  var topConstraint: Constraint? = nil
  var topToTimeConstraint: Constraint? = nil
  var topToTextConstraint: Constraint? = nil
  
  override func initialize() {
    super.initialize()
    self.contentView.addSubview(self.fileView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.fileView.snp.makeConstraints { [weak self] (make) in
      make.height.equalTo(FileMessageView.Metric.HEIGHT)
      self?.topConstraint = make.top.equalToSuperview().inset(5).priority(850).constraint
      self?.topToTimeConstraint = make.top.equalTo((self?.timestampLabel.snp.bottom)!).offset(3).priority(750).constraint
      self?.topToTextConstraint = make.top.equalTo((self?.textMessageView.snp.bottom)!).offset(3).constraint
      self?.rightConstraint = make.right.equalToSuperview().inset(Metric.cellRightPadding).constraint
      self?.leftConstraint = make.left.equalToSuperview().inset(Metric.messageLeftMinMargin).constraint
    }
    
    self.resendButtonView.snp.remakeConstraints { [weak self] (make) in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.bottom.equalTo((self?.fileView.snp.bottom)!)
      make.right.equalTo((self?.fileView.snp.left)!).inset(4)
    }
  }
  
  override func configure(_ viewModel: MessageCellModelType, presenter: ChatManager? = nil) {
    super.configure(viewModel, presenter: presenter)
    self.fileView.configure(message: viewModel)
    
    if viewModel.isContinuous {
      self.topConstraint?.activate()
      self.topToTimeConstraint?.deactivate()
      self.topToTextConstraint?.deactivate()
    } else if self.textMessageView.messageView.text == "" {
      self.topConstraint?.deactivate()
      self.topToTimeConstraint?.activate()
      self.topToTextConstraint?.deactivate()
    } else {
      self.topConstraint?.deactivate()
      self.topToTimeConstraint?.deactivate()
      self.topToTextConstraint?.activate()
    }
    
    if viewModel.createdByMe == true {
      self.rightConstraint?.update(inset: Metric.cellRightPadding)
      self.leftConstraint?.update(inset: Metric.messageLeftMinMargin)
    } else {
      self.rightConstraint?.update(inset: Metric.messageRightMinMargin)
      self.leftConstraint?.update(inset: Metric.bubbleLeftMargin)
    }
  }
  
  override class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var height = super.cellHeight(fits: width, viewModel: viewModel)
    height += 3
    height += FileMessageView.viewHeight(fits: width, viewModel: viewModel)
    return height
  }
}

