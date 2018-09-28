//
//  TextMessageView.swft
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 20..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import SnapKit

let placeHolder = UITextView()
  .then {
    $0.textContainer.lineFragmentPadding = 0
    $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
  }

class TextMessageView : BaseView {
  struct Metric {
    static let topBottomPadding = 10.f
    static let leftRightPadding = 12.f
    static let minimalTopBottomPadding = 2.f
    static let minimalLeftRightPadding = 5.f
  }

  struct Constant {
    static let cornerRadius = 12.f
    static let singleCornerRadius = 2.f
    static let actionViewBottomRadius = 12.f
    static let borderWidth: CGFloat = 1
  }

  struct Font {
    static let actionLabel = UIFont.boldSystemFont(ofSize: 13)
    static let messageView = UIFont.systemFont(ofSize: 15)
  }

  struct Color {
    static let actionLabel = CHColors.blueyGrey
    static let message = UIColor.black
  }

  //MARK: Properties

  let messageView = UITextView().then {
    $0.font = Font.messageView
    $0.textAlignment = NSTextAlignment.left
    $0.backgroundColor = UIColor.clear
    $0.isScrollEnabled = false
    $0.isEditable = false
    $0.isSelectable = true
    
    $0.dataDetectorTypes = [.link, .phoneNumber]
    $0.textContainer.lineFragmentPadding = 0
    $0.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 3)
  }

  var viewModel: MessageCellModelType?
  
  var topConstraint: Constraint?
  var leadingConstraint: Constraint?
  var trailingConstraint: Constraint?
  var bottomConstraint: Constraint?
  
  override func initialize() {
    super.initialize()
    self.messageView.delegate = self
    
    self.layer.cornerRadius = Constant.singleCornerRadius
    self.addSubview(self.messageView)
  }
  
  override func setLayouts() {
    super.setLayouts()

    self.messageView.snp.makeConstraints({ [weak self] (make) in
      self?.leadingConstraint = make.leading.equalToSuperview().inset(Metric.leftRightPadding).constraint
      self?.topConstraint = make.top.equalToSuperview().inset(Metric.topBottomPadding).constraint
      self?.trailingConstraint = make.trailing.equalToSuperview().inset(Metric.leftRightPadding).constraint
      self?.bottomConstraint = make.bottom.equalToSuperview().inset(Metric.topBottomPadding).constraint
    })
  }

  func configure(_ viewModel: MessageCellModelType) {
    self.viewModel = viewModel
    self.backgroundColor = viewModel.message.onlyEmoji == true ?
      UIColor.clear : viewModel.bubbleBackgroundColor
    self.isHidden = viewModel.message.isEmpty()
    
    if !viewModel.message.onlyEmoji {
      self.leadingConstraint?.update(inset: Metric.leftRightPadding)
      self.trailingConstraint?.update(inset: Metric.leftRightPadding)
      self.topConstraint?.update(inset: Metric.topBottomPadding)
      self.bottomConstraint?.update(inset: Metric.topBottomPadding)
    } else {
      self.leadingConstraint?.update(inset: Metric.minimalLeftRightPadding)
      self.trailingConstraint?.update(inset: Metric.minimalLeftRightPadding)
      self.topConstraint?.update(inset: Metric.minimalTopBottomPadding)
      self.bottomConstraint?.update(inset: Metric.minimalTopBottomPadding)
    }
    
    if viewModel.translateState == .translated {
      if let translated = self.viewModel?.message.translatedText {
        self.messageView.attributedText = translated
      }
    } else if let attributedText = viewModel.message.messageV2 {
      self.messageView.attributedText = attributedText
    } else {
      self.messageView.text = viewModel.message.message
    }
    
    self.messageView.textColor = viewModel.createdByMe ? viewModel.textColor : Color.message
    let linkColor = viewModel.createdByMe ? viewModel.textColor : CHColors.cobalt
    self.messageView.linkTextAttributes = [
      NSAttributedStringKey.foregroundColor.rawValue: linkColor,
      NSAttributedStringKey.underlineStyle.rawValue: 1]
  }
  
  override func updateConstraints() {
    super.updateConstraints()
    
    if self.viewModel?.isContinuous == true {
      self.roundCorners(corners: [.allCorners], radius: Constant.cornerRadius)
    } else if self.viewModel?.createdByMe == true {
      self.roundCorners(corners: [.topLeft, .bottomRight, .bottomLeft], radius: Constant.cornerRadius)
    } else {
      self.roundCorners(corners: [.topRight, .bottomRight, .bottomLeft], radius: Constant.cornerRadius)
    }
  }
  
  class func viewHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var viewHeight : CGFloat = 0.0
    if let message = viewModel.message.messageV2 {
      let maxWidth = !viewModel.message.onlyEmoji ?
        width - Metric.leftRightPadding * 2 :
        width - Metric.minimalLeftRightPadding * 2
      
      let topBottomPadding = viewModel.message.onlyEmoji ?
        Metric.minimalTopBottomPadding * 2 : Metric.topBottomPadding * 2
      
      placeHolder.frame = CGRect(x: 0, y: 0, width: maxWidth, height: CGFloat.greatestFiniteMagnitude)
      placeHolder.textContainer.lineFragmentPadding = 0
      placeHolder.attributedText = message
      placeHolder.sizeToFit()
      
      viewHeight += placeHolder.size.height + topBottomPadding
//      viewHeight += message.height(fits: width - Metric.leftRightPadding * 2)
//      viewHeight += Metric.topBottomPadding * 2
    }
    
    return viewHeight
  }
}

extension TextMessageView : UITextViewDelegate {
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange) -> Bool {
    let shouldhandle = ChannelIO.delegate?.onClickChatLink?(url: URL)
    let scheme = URL.scheme ?? ""
    switch scheme {
    case "tel":
      return true
    case "mailto":
      return true
    default:
      return shouldhandle == true || shouldhandle == nil
    }
  }
  
  @available(iOS 10.0, *)
  func textView(_ textView: UITextView,
                shouldInteractWith URL: URL,
                in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if interaction == .invokeDefaultAction {
      let scheme = URL.scheme ?? ""
      switch scheme {
      case "tel":
        return true
      case "mailto":
        return true
      default:
        let handled = ChannelIO.delegate?.onClickChatLink?(url: URL)
        if handled == false || handled == nil {
          URL.openWithUniversal()
        }
        return false
      }
    }
    
    return true
  }

}
