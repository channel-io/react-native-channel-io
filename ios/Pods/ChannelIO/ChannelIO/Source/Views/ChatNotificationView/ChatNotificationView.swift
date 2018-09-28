//
//  ChatNotificationView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 09/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import RxSwift
import SnapKit

final class ChatNotificationView : BaseView {
  var topLayoutGuide: UILayoutSupport?
  
  // MARK: Constants
  struct Metric {
    static let sideMargin = 12.f
    static let topMargin = 10.f
    static let boxHeight = 68.f
    static let viewTopMargin = 20.f
    static let viewSideMargin = 14.f
    static let avatarSide = 46.f
    static let avatarTopMargin = 10.f
    static let avatarLeftMargin = 8.f
    static let nameTopMargin = 12.f
    static let nameLeftMargin = 8.f
    static let timestampTopMargin = 0.f
    static let closeSide = 44.f
    static let messageTopMargin = 3.f
    static let messageRightMargin = 29.f
    static let messageBotMargin = 12.f
    static let messageLeftMargin = 8.f
  }
  
  struct Font {
    static let messageLabel = UIFont.systemFont(ofSize: 14)
    static let nameLabel = UIFont.boldSystemFont(ofSize: 13)
    static let timestampLabel = UIFont.systemFont(ofSize: 11)
  }
  
  struct Color {
    static let border = CHColors.white.cgColor
    static let messageLabel = CHColors.charcoalGrey
    static let nameLabel = CHColors.charcoalGrey
    static let timeLabel = CHColors.warmGrey
  }
  
  struct Constant {
    static let titleLabelNumberOfLines = 1
    static let messageLabelNumberOfLines = 4
    static let timestampLabelNumberOfLines = 1
    static let nameLabelNumberOfLines = 1
    static let cornerRadius = 8.f
    static let shadowColor = CHColors.dark.cgColor
    static let shadowOffset = CGSize(width: 0.f, height: 5.f)
    static let shadowBlur = 20.f
    static let shadowOpacity = 0.4.f
  }

  // MARK: Properties
  let messageView = UITextView().then {
    $0.isScrollEnabled = false
    $0.isEditable = false
    $0.font = Font.messageLabel
    $0.textColor = Color.messageLabel
    $0.textContainer.maximumNumberOfLines = 3
    $0.textContainer.lineBreakMode = .byTruncatingTail
    
    $0.dataDetectorTypes = [.link, .phoneNumber]
    $0.textContainer.lineFragmentPadding = 0
    $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
    
    $0.linkTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: CHColors.cobalt,
      NSAttributedStringKey.underlineStyle.rawValue: 0
    ]
  }
  
  let nameLabel = UILabel().then {
    $0.font = Font.nameLabel
    $0.textColor = Color.nameLabel
    $0.numberOfLines = Constant.nameLabelNumberOfLines
  }
  
  let timestampLabel = UILabel().then {
    $0.font = Font.timestampLabel
    $0.textColor = Color.timeLabel
    $0.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 1000), for: .horizontal)
  }
  
  let avatarView = AvatarView().then {
    $0.showBorder = true
    $0.borderColor = UIColor.white
  }
  
  let closeView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "cancelSmall")
    $0.contentMode = UIViewContentMode.center
    $0.layer.shadowOpacity = 0
  }
  
  let chatSignal = PublishSubject<Any?>()
  let disposeBag = DisposeBag()
  
  override func initialize() {
    super.initialize()
    
    self.backgroundColor = CHColors.white
    
    self.layer.cornerRadius = Constant.cornerRadius
    self.layer.shadowColor = Constant.shadowColor
    self.layer.shadowOffset = Constant.shadowOffset
    self.layer.shadowRadius = Constant.shadowBlur
    self.layer.shadowOpacity = Float(Constant.shadowOpacity)
    
    self.avatarView.layer.shadowColor = CHColors.dark10.cgColor
    self.avatarView.layer.shadowOffset = CGSize(width: 0.f, height: 2.f)
    self.avatarView.layer.shadowRadius = 4
    self.avatarView.layer.shadowOpacity = Float(Constant.shadowOpacity)
    
    self.messageView.delegate = self
    
    self.addSubview(self.nameLabel)
    self.addSubview(self.messageView)
    self.addSubview(self.timestampLabel)
    self.addSubview(self.avatarView)
    self.addSubview(self.closeView)
    
    self.signalForClick().subscribe(onNext: { [weak self] (_) in
      self?.chatSignal.onNext(nil)
      self?.chatSignal.onCompleted()
    }).disposed(by: self.disposeBag)
    
    self.messageView.signalForClick().subscribe(onNext: { [weak self] (_) in
      self?.chatSignal.onNext(nil)
      self?.chatSignal.onCompleted()
    }).disposed(by: self.disposeBag)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.avatarView.snp.makeConstraints { (make) in
      make.size.equalTo(CGSize(width: Metric.avatarSide, height: Metric.avatarSide))
      make.leading.equalToSuperview().offset(14)
      make.top.equalToSuperview().inset(-12)
    }
    
    self.nameLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalTo((self?.avatarView.snp.trailing)!).offset(8)
      make.top.equalToSuperview().inset(16)
    }

    self.timestampLabel.snp.makeConstraints { [weak self] (make) in
      make.leading.equalTo((self?.nameLabel.snp.trailing)!).offset(6)
      make.centerY.equalTo((self?.nameLabel.snp.centerY)!)
    }
    
    self.messageView.snp.makeConstraints { [weak self] (make) in
      make.leading.equalToSuperview().inset(14)
      make.top.equalTo((self?.nameLabel.snp.bottom)!).offset(12)
      make.bottom.equalToSuperview().inset(18)
      make.trailing.equalToSuperview().inset(14)
    }
    
    self.closeView.snp.makeConstraints { [weak self] (make) in
      make.size.equalTo(CGSize(width:Metric.closeSide, height:Metric.closeSide))
      make.top.equalToSuperview()
      make.leading.greaterThanOrEqualTo((self?.timestampLabel.snp.trailing)!).offset(5)
      make.trailing.equalToSuperview()
    }
  }
  
  func configure(_ viewModel: ChatNotificationViewModelType) {
    self.messageView.attributedText = viewModel.message
    self.nameLabel.text = viewModel.name
    self.avatarView.configure(viewModel.avatar)
    self.timestampLabel.text = viewModel.timestamp
  }
  
  override func updateConstraints() {
    self.snp.remakeConstraints { [weak self] (make) in
      if let top = self?.topLayoutGuide {
        make.top.equalTo(top.snp.bottom).offset(Metric.viewTopMargin)
      } else {
        make.top.equalToSuperview().inset(Metric.viewTopMargin)
      }
      
      make.leading.equalToSuperview().inset(Metric.viewSideMargin)
      make.trailing.equalToSuperview().inset(Metric.viewSideMargin)
    }
   
    super.updateConstraints()
  }
  
  func signalForChat() -> Observable<Any?> {
    return self.chatSignal.asObservable()
  }
}

extension ChatNotificationView : UITextViewDelegate {
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange) -> Bool {
    let shouldhandle = ChannelIO.delegate?.onClickChatLink?(url: URL)
    return shouldhandle == true || shouldhandle == nil
  }

  @available(iOS 10.0, *)
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if interaction == .invokeDefaultAction {
      let handled = ChannelIO.delegate?.onClickChatLink?(url: URL)
      if handled == false || handled == nil {
        URL.openWithUniversal()
      }
      return false
    }
    
    return true
  }
}

