//
//  TokenView.swift
//  ChannelIO
//
//  Created by Haeun Chung on 11/06/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import SnapKit

enum ActionAlignment {
  case left
  case right
}

typealias SubmitForm = (String, String)

//make it more user friendly with uicontrol`
class ActionButton: UIButton {
  var key: String = ""
  var text: NSAttributedString? = nil
  var selectedColor: UIColor? = nil
  var selectedTextColor: UIColor? = nil {
    didSet {
      self.setTitleColor(selectedTextColor, for: .highlighted)
    }
  }
  
  override open var isHighlighted: Bool {
    didSet {
      self.backgroundColor = isHighlighted ? selectedColor : UIColor.white
      if isHighlighted {
        self.layer.shadowColor = CHColors.dark50.cgColor
        self.layer.shadowOpacity = 0.8
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4
        self.layer.borderWidth = 0
      } else {
        self.layer.shadowColor = UIColor.clear.cgColor
        self.layer.shadowOpacity = 0
        self.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.layer.shadowRadius = 0
        self.layer.borderWidth = 1
        self.layer.borderColor = CHColors.dark50.cgColor
      }
    }
  }
  
  struct Metric {
    static let topBottomMargin = 10.f
    static let sideMargin = 12.f
  }
  
  struct Constant {
    static let maxWidth = UIScreen.main.bounds.width - 10.f - 65.f
  }
  
  required init(input: CHInput) {
    super.init(frame: CGRect.zero)
    self.text = input.text
    self.key = input.key
    
    self.text = self.text?.addFont(
      input.onlyEmoji ? UIFont.systemFont(ofSize: 20) : UIFont.systemFont(ofSize: 15),
      color: CHColors.dark50,
      on: NSRange(location:0, length: input.text?.length ?? 0))
  
    self.setAttributedTitle(self.text, for: .normal)
    self.titleLabel?.lineBreakMode = .byTruncatingTail
    self.titleLabel?.numberOfLines = 2
    self.titleEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
    self.titleLabel?.preferredMaxLayoutWidth = Constant.maxWidth
    self.setTitleColor(CHColors.dark50, for: .normal)
 
    self.layer.cornerRadius = 15.f
    self.layer.borderWidth = 1.f
    self.layer.borderColor = CHColors.dark50.cgColor
    

    let size = self.text?.size(
      fits: CGSize(width: Constant.maxWidth, height: 10000),
      maximumNumberOfLines: 2) ?? CGSize.zero
    
    self.frame = CGRect(x: 0, y: 0,
        width: size.width + Metric.sideMargin * 2,
        height: size.height + Metric.topBottomMargin * 2)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class ActionView: BaseView {
  var buttons: [ActionButton] = []
  var contentView = UIView()
  var alignment: ActionAlignment = .right
  var actionSubject = PublishSubject<SubmitForm>()
  
  struct Constant {
    static let maxWidth = UIScreen.main.bounds.width - 10.f - 65.f
  }
  
  struct Metric {
    static let itemBetweenMargin = 4.f
    static let topBottomMargin = 10.f
    static let sideMargin = 12.f
  }
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.contentView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.contentView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
  }
  
  func configure(_ viewModel: MessageCellModelType) {
    for view in self.contentView.subviews {
      view.removeFromSuperview()
    }
    self.buttons.removeAll()
    
    guard viewModel.shouldDisplayForm else { return }
    guard let inputs = viewModel.message.form?.inputs, inputs.count > 0 else { return }
    
    for input in inputs {
      let button = ActionButton(input: input)
      button.selectedColor = viewModel.pluginColor
      button.selectedTextColor = viewModel.textColor
      
      self.contentView.addSubview(button)
      self.buttons.append(button)
      _ = button.signalForClick().subscribe(onNext: { [weak self] (_) in
        self?.actionSubject.onNext((button.key, button.text?.string ?? ""))
      })
    }
    
    //layouts them based on width
    var cx = 0.f, cy = 0.f
    var firstRowIndex = 0
    var lastButton: ActionButton!
    
    for (index, button) in self.buttons.enumerated() {
      if Constant.maxWidth < cx + button.frame.width {
        let calcualtedY = lastButton.frame.origin.y + lastButton.frame.height + 4.f
        button.frame.origin = CGPoint(x: 0.f, y: calcualtedY)
        
        if self.alignment == .right {
          let buttons = Array(self.buttons[firstRowIndex..<index])
          self.realignItemsToRight(buttons: buttons)
        }

        cx = button.frame.width + 4.f
        cy += button.frame.height + 4.f
        firstRowIndex = index
      } else {
        button.frame.origin = CGPoint(x: cx, y: cy)
        cx += button.frame.width + 4.f
      }
      
      lastButton = button
    }
    
    if self.alignment == .right {
      let buttons = Array(self.buttons[firstRowIndex..<self.buttons.count])
      self.realignItemsToRight(buttons: buttons)
    }
  }
  
  private func realignItemsToRight(buttons: [ActionButton]) {
    let leftOverMargin =  UIScreen.main.bounds.width - 10 -
      (buttons.last?.frame.origin.x ?? 0) - (buttons.last?.frame.width ?? 0)
    guard  leftOverMargin > 0 else { return }
    
    for button in buttons {
      button.origin = CGPoint(x: button.origin.x + leftOverMargin, y: button.origin.y)
    }
  }

  func observeAction() -> Observable<SubmitForm> {
    return self.actionSubject.asObservable()
  }
  
  class func viewHeight(fits width: CGFloat, inputs: [CHInput]) -> CGFloat {
    var cx = 0.f, cy = 0.f

    for (index, input) in inputs.enumerated() {
      let size = input.text?.size(
        fits: CGSize(width: Constant.maxWidth, height: 10000),
        maximumNumberOfLines: 2) ?? CGSize.zero
      
      let width = size.width + Metric.sideMargin * 2
      let height = size.height + Metric.topBottomMargin * 2
      
      if Constant.maxWidth < cx + width {
        cy += height + Metric.itemBetweenMargin
        cx = width  + Metric.itemBetweenMargin
      } else {
        cx += width + Metric.itemBetweenMargin
      }
      
      if index == inputs.count - 1 {
        cy += height
      }
    }
    
    return cy
  }
}

