//
//  ErrorToastView.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 15..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import SnapKit

final class ErrorToastView: BaseView {

  // MARK: - Constants

  struct Font {
    static let title = UIFont.boldSystemFont(ofSize: 13)
  }

  struct Color {
    static let background = CHColors.yellow
    static let title = CHColors.white
  }

  struct Metric {
    static let height = 40.f
    static let iconWidth = 40.f
  }

  // MARK: -Properties
  
  //provide useful error message
  var errorMessage: String {
    set {
      self.titleLabel.text = CHAssets.localized(newValue)
    }
    get {
      return self.titleLabel.text!
    }
  }
  
  let titleLabel = UILabel().then {
    $0.font = Font.title
    $0.textColor = Color.title
    $0.text = CHAssets.localized("ch.toast.unstable_internet")
  }

  let refreshImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "refresh")
  }

  weak var topLayoutGuide: UILayoutSupport? = nil
  weak var containerView: UIView!
  var topConstraint: Constraint? = nil

  // MARK: - Initialize

  override func initialize() {
    self.backgroundColor = Color.background
    self.addSubview(self.titleLabel)
    self.addSubview(self.refreshImageView)
  }

  // MARK: - Layout

  override func updateConstraints() {
    self.snp.remakeConstraints ({ [weak self] (make) in
      make.width.equalToSuperview()
      make.height.equalTo(Metric.height)
      
      if let top = self?.topLayoutGuide {
        self?.topConstraint = make.top.equalTo(top.snp.bottom)
          .inset(Metric.height).constraint
      } else {
        self?.topConstraint = make.top.equalToSuperview()
          .inset(Metric.height).constraint
      }
    })

    self.titleLabel.snp.remakeConstraints { (make) in
      make.center.equalToSuperview()
    }

    self.refreshImageView.snp.remakeConstraints { (make) in
      make.width.equalTo(Metric.iconWidth)
      make.height.equalTo(Metric.iconWidth)
      make.centerY.equalToSuperview()
      make.trailing.equalToSuperview().inset(4)
    }

    super.updateConstraints()
  }
  
  func display(animated: Bool) {
    if !self.isHidden {
      return
    }
    
    self.isHidden = false
    self.topConstraint?.update(inset: 0)
    UIView.animate(withDuration: 0.3) {
      self.containerView.layoutIfNeeded()
    }
  }
  
  func dismiss(animated: Bool) {
    if self.isHidden {
      return
    }
    
    self.isHidden = true
    self.topConstraint?.update(inset: self.frame.height)
    self.containerView.layoutIfNeeded()
  }

}
