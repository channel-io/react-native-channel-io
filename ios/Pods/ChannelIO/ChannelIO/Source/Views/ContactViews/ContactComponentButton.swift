//
//  ContactComponentView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 29/11/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//
import UIKit
import RxSwift

class ContactComponentButton: BaseButton {
  var action: (() -> Void)? = nil
  var disposeBag = DisposeBag()
  var normalColor: UIColor? = nil
  var highlightColor: UIColor? = nil
  
  override var isHighlighted: Bool {
    didSet {
      if isHighlighted {
        self.backgroundColor = self.highlightColor
      } else {
        self.backgroundColor = self.normalColor
      }
    }
  }
  init(image: UIImage, action:(() -> Void)? = nil) {
    super.init(frame: CGRect.zero)
   
    self.action = action
    self.setImage(image, for: .normal)
    self.setImage(image, for: .highlighted)
    
    self.signalForClick()
      .observeOn(MainScheduler.instance)
      .subscribe { [weak self] (_) in
      self?.action?()
    }.disposed(by: self.disposeBag)
  }
  
  func setBackgroundColorsWith(baseColor: UIColor) {
    if baseColor == UIColor.white {
      self.normalColor = CHColors.white15
      self.highlightColor = CHColors.white40
    } else {
      self.normalColor = CHColors.dark5
      self.highlightColor = CHColors.dark20
    }
    
    self.backgroundColor = self.normalColor
  }
  
  func setBackgroundColors(normal: UIColor, highlight: UIColor) {
    self.normalColor = normal
    self.highlightColor = highlight
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }

}
