//
//  MessageCell.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import Reusable
import SnapKit

class MessageCell: BaseTableViewCell, Reusable {
  weak var presenter: ChatManager? = nil
  // MARK: Constants
  struct Font {
    static let usernameLabel = UIFont.boldSystemFont(ofSize: 12)
    static let timestampLabel = UIFont.systemFont(ofSize: 11)
  }
  
  struct Color {
    static let username = CHColors.dark
    static let timestamp = CHColors.blueyGrey
  }

  struct Metric {
    static let cellRightPadding = 10.f
    static let cellLeftPadding = 10.f
    static let messageLeftMinMargin = 107.f
    static let messageRightMinMargin = 74.f
    static let messageTop = 4.f
    static let avatarWidth = 26.f
    static let avatarRightPadding = 6.f
    static let bubbleLeftMargin = 40.f
    static let usernameHeight = 16.f
    static let usernameLeading = 8.f
    static let timestampLeading = 6.f
    static let cellTopPaddingOfContinous = 3.f
    static let cellTopPaddingDefault = 16.f
    static let translateViewTop = 4.f
    static let translateViewLeading = 12.f
  }
  
  let avatarView = AvatarView().then {
    $0.showBorder = false
    $0.showOnline = false
    $0.layer.cornerRadius = 13.f
  }
  
  let usernameLabel = UILabel().then {
    $0.font = Font.usernameLabel
    $0.textColor = Color.username
  }
  
  let timestampLabel = UILabel().then {
    $0.font = Font.timestampLabel
    $0.textColor = Color.timestamp
  }
  
//  let titleLabel = UILabel().then {
//    $0.textColor = CHColors.charcoalGrey
//    $0.font = UIFont.boldSystemFont(ofSize: 16)
//  }
  
  let textMessageView = TextMessageView()
  let translateView = TranslateView()
  let resendButtonView = UIButton().then {
    $0.isHidden = true
    $0.setImage(CHAssets.getImage(named: "resend"), for: .normal)
  }

  var viewModel: MessageCellModelType?
  var titleHeightConstraint: Constraint? = nil
  // MARK: Initializing

  override func initialize() {
    super.initialize()

    self.contentView.addSubview(self.avatarView)
    self.contentView.addSubview(self.usernameLabel)
    self.contentView.addSubview(self.timestampLabel)
    //self.contentView.addSubview(self.titleLabel)
    self.contentView.addSubview(self.textMessageView)
    self.contentView.addSubview(self.translateView)
    self.contentView.addSubview(self.resendButtonView)

    self.resendButtonView.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.presenter?.didClickOnRetry(for: self?.viewModel?.message)
        self?.resendButtonView.isHidden = true
      }).disposed(by :self.disposeBag)
    
    self.translateView.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.presenter?.didClickOnTranslate(for: self?.viewModel?.message)
      }).disposed(by: self.disposeBag)
  }

  // MARK: Configuring
  func configure(_ viewModel: MessageCellModelType, presenter: ChatManager? = nil) {
    self.presenter = presenter 
    self.viewModel = viewModel
    
    self.usernameLabel.text = viewModel.name
    self.usernameLabel.isHidden = viewModel.usernameIsHidden
    
    self.timestampLabel.text = viewModel.timestamp
    self.timestampLabel.isHidden = viewModel.timestampIsHidden
    
    self.avatarView.configure(viewModel.avatarEntity)
    self.avatarView.isHidden = viewModel.avatarIsHidden
    
    self.textMessageView.configure(viewModel)
    self.resendButtonView.isHidden = !viewModel.isFailed
    
    self.translateView.configure(with: viewModel)
    self.translateView.isHidden = !viewModel.showTranslation
    
    self.layoutViews()
    self.textMessageView.updateConstraints()
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.avatarView.snp.makeConstraints({ make in
      make.leading.equalToSuperview().offset(Metric.cellLeftPadding)
      make.top.equalToSuperview().inset(Metric.cellTopPaddingDefault)
      make.size.equalTo(CGSize(width: Metric.avatarWidth, height: Metric.avatarWidth))
    })
    
    self.usernameLabel.snp.makeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.avatarView.snp.right)!).offset(Metric.usernameLeading)
      make.top.equalTo((self?.avatarView.snp.top)!)
      make.height.equalTo(Metric.usernameHeight)
    })
    
    self.timestampLabel.snp.makeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.usernameLabel.snp.right)!).offset(Metric.timestampLeading)
      make.centerY.equalTo((self?.usernameLabel)!)
    })
    
//    self.titleLabel.snp.makeConstraints { [weak self] (make) in
//      make.left.equalToSuperview().inset(Metric.bubbleLeftMargin)
//      make.right.lessThanOrEqualToSuperview().inset(Metric.messageLeftMinMargin)
//      make.top.equalTo((self?.usernameLabel.snp.bottom)!).offset(Metric.messageTop)
//    }
//
    self.textMessageView.snp.makeConstraints({ [weak self] (make) in
      make.left.equalToSuperview().inset(Metric.bubbleLeftMargin)
      make.right.lessThanOrEqualToSuperview().inset(Metric.messageLeftMinMargin)
      make.top.equalTo((self?.usernameLabel.snp.bottom)!).offset(Metric.messageTop)
      //make.top.equalTo((self?.titleLabel.snp.bottom)!).offset(Metric.messageTop)
    })
    
    self.translateView.snp.makeConstraints { [weak self] (make) in
      make.top.equalTo((self?.textMessageView.snp.bottom)!).offset(Metric.translateViewTop)
      make.leading.equalTo((self?.textMessageView.snp.leading)!).offset(Metric.translateViewLeading)
    }
    
    self.resendButtonView.snp.remakeConstraints({ [weak self] (make) in
      make.size.equalTo(CGSize(width: 40, height: 40))
      make.bottom.equalTo((self?.textMessageView.snp.bottom)!)
      make.right.equalTo((self?.textMessageView.snp.left)!).inset(4)
    })
  }
  
  class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var viewHeight : CGFloat = 0.0
    
    if viewModel.isContinuous == true {
      viewHeight += Metric.cellTopPaddingOfContinous
    } else {
      viewHeight += Metric.cellTopPaddingDefault + Metric.usernameHeight + 4
    }

    let bubbleMaxWidth = viewModel.createdByMe ?
      width - Metric.messageLeftMinMargin - Metric.cellRightPadding :
      width - Metric.messageRightMinMargin - Metric.bubbleLeftMargin

    if viewModel.message.messageV2?.string != "" {
      viewHeight += TextMessageView.viewHeight(fits: bubbleMaxWidth, viewModel: viewModel)
    }
    
    if viewModel.showTranslation {
      viewHeight += 20
    }
    
    return viewHeight
  }
}

// MARK: layout
extension MessageCell {
  func layoutViews() {
    if self.viewModel?.createdByMe == true {
      if self.viewModel?.isContinuous == true {
        self.layoutCoutinuousByMe()
      } else {
        self.layoutDefaultByMe()
      }
    } else {
      if self.viewModel?.isContinuous == true {
        self.layoutContinuousByOther()
      } else {
        self.layoutDefaultByOther()
      }
    }
  }
  
  func layoutCoutinuousByMe() {
    self.textMessageView.snp.remakeConstraints({ [weak self] (make) in
      make.left.greaterThanOrEqualToSuperview().inset(Metric.messageLeftMinMargin)
      make.right.equalToSuperview().inset(Metric.cellRightPadding)
      if self?.textMessageView.messageView.text == "" {
        make.top.equalToSuperview()
      } else {
        make.top.equalToSuperview().inset(Metric.cellTopPaddingOfContinous)
      }
    })
  }
  
  func layoutDefaultByMe() {
    self.timestampLabel.snp.remakeConstraints({ (make) in
      make.trailing.equalToSuperview().inset(Metric.cellRightPadding)
      make.top.equalToSuperview().inset(Metric.cellTopPaddingDefault)
    })
    
    self.usernameLabel.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.avatarView.snp.right)!).offset(0)
      make.top.equalTo((self?.avatarView.snp.top)!)
    })
    
    self.textMessageView.snp.remakeConstraints({ [weak self] (make) in
      make.left.greaterThanOrEqualToSuperview().inset(Metric.messageLeftMinMargin)
      make.right.equalToSuperview().inset(Metric.cellRightPadding)
      make.top.equalTo((self?.timestampLabel.snp.bottom)!).offset(4)
    })
  }
  
  func layoutContinuousByOther() {
    self.avatarView.snp.remakeConstraints({ make in
      make.leading.equalToSuperview().offset(Metric.cellLeftPadding)
      make.top.equalToSuperview().inset(Metric.cellTopPaddingOfContinous)
      make.size.equalTo(CGSize(width: Metric.avatarWidth, height: Metric.avatarWidth))
    })
    
    self.usernameLabel.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.avatarView.snp.right)!).offset(8)
      make.top.equalTo((self?.avatarView.snp.top)!)
      make.height.equalTo(Metric.usernameHeight)
    })
    
    self.timestampLabel.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.usernameLabel.snp.right)!).offset(6)
      make.centerY.equalTo((self?.usernameLabel)!)
    })
    
    self.textMessageView.snp.remakeConstraints({ (make) in
      make.left.equalToSuperview().inset(Metric.bubbleLeftMargin)
      make.right.lessThanOrEqualToSuperview().inset(Metric.messageRightMinMargin)
      make.top.equalToSuperview().inset(Metric.cellTopPaddingOfContinous)
    })
  }
  
  func layoutDefaultByOther() {
    self.avatarView.snp.remakeConstraints({ make in
      make.leading.equalToSuperview().offset(Metric.cellLeftPadding)
      make.top.equalToSuperview().inset(Metric.cellTopPaddingDefault)
      make.size.equalTo(CGSize(width: Metric.avatarWidth, height: Metric.avatarWidth))
    })
    
    self.usernameLabel.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.avatarView.snp.right)!).offset(8)
      make.top.equalTo((self?.avatarView.snp.top)!)
      make.height.equalTo(Metric.usernameHeight)
    })
    
    self.timestampLabel.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalTo((self?.usernameLabel.snp.right)!).offset(6)
      make.centerY.equalTo((self?.usernameLabel)!)
    })
    
    self.textMessageView.snp.remakeConstraints({ [weak self] (make) in
      make.left.equalToSuperview().inset(Metric.bubbleLeftMargin)
      make.right.lessThanOrEqualToSuperview().inset(Metric.messageRightMinMargin)
      make.top.equalTo((self?.usernameLabel.snp.bottom)!).offset(4)
    })
  }
}
