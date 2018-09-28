//
//  ImageMessageCell.swift
//  CHPlugin
//
//  Created by Haeun Chung on 26/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class MediaMessageCell: MessageCell {
  let mediaView = MediaMessageView().then {
    $0.backgroundColor = UIColor.white
  }
  
  var leftConstraint: Constraint? = nil
  var rightConstraint: Constraint? = nil
  var widthConstraint: Constraint? = nil
  var heightConstraint: Constraint? = nil
  
  var topConstraint: Constraint? = nil
  var topToTextConstraint: Constraint? = nil
  var topToTimeConstraint: Constraint? = nil
  
  override func prepareForReuse() {
    self.mediaView.imageView.image = nil
  }
  
  override func initialize() {
    super.initialize()
    self.contentView.addSubview(self.mediaView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.mediaView.snp.remakeConstraints { [weak self] (make) in
      self?.widthConstraint = make.width.equalTo(0).constraint
      self?.heightConstraint = make.height.equalTo(0).constraint
      
      self?.rightConstraint = make.right.equalToSuperview().inset(Metric.cellRightPadding).constraint
      self?.leftConstraint = make.left.equalToSuperview().inset(Metric.bubbleLeftMargin).constraint
      
      self?.topToTimeConstraint = make.top.equalTo((self?.timestampLabel.snp.bottom)!).offset(3).priority(800).constraint
      self?.topToTextConstraint = make.top.equalTo((self?.textMessageView.snp.bottom)!).offset(3).priority(750).constraint
      self?.topConstraint = make.top.equalToSuperview().inset(5).constraint
    }
    
    self.resendButtonView.snp.remakeConstraints { [weak self] (make) in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.bottom.equalTo((self?.mediaView.snp.bottom)!).offset(10)
      make.right.equalTo((self?.mediaView.snp.left)!).offset(4)
    }
  }
  
  override func configure(_ viewModel: MessageCellModelType, presenter: ChatManager? = nil) {
    super.configure(viewModel, presenter: presenter)
    self.mediaView.configure(message: viewModel, isThumbnail: true)
    
    let size = MediaMessageView.viewSize(fits: self.width, viewModel: viewModel)
    self.widthConstraint?.update(offset: size.width)
    self.heightConstraint?.update(offset: size.height)
    
    if viewModel.isContinuous {
      self.topConstraint?.activate()
      self.topToTextConstraint?.deactivate()
      self.topToTimeConstraint?.deactivate()
    } else if self.textMessageView.messageView.text == "" {
      self.topConstraint?.deactivate()
      self.topToTimeConstraint?.activate()
      self.topToTextConstraint?.deactivate()
    } else {
      self.topConstraint?.deactivate()
      self.topToTimeConstraint?.deactivate()
      self.topToTextConstraint?.activate()
    }
    
    if self.viewModel?.createdByMe == true {
      self.rightConstraint?.activate()
      self.leftConstraint?.deactivate()
    } else {
      self.rightConstraint?.deactivate()
      self.leftConstraint?.activate()
    }
  }
  
  override class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var height = super.cellHeight(fits: width, viewModel: viewModel)
    height += 3
    height += MediaMessageView.viewSize(fits: width, viewModel: viewModel).height
    return height
  }
}
