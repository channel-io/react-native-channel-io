//
//  ProfileCell.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/11/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import Reusable
import SnapKit
import RxSwift

protocol Actionable: class {
  func signalForAction() -> Observable<Any?>
  func signalForText() -> Observable<String?>
  func signalForFocus() -> Observable<Bool>
  func setLoading()
  func setFocus()
  func setOutFocus()
  func setInvalid()
  
  var didFocus: Bool { get set }
  var view: UIView { get }
}

extension Actionable where Self: UIView {
  var view: UIView { return self }
}

protocol ProfileContentProtocol: class {
  var view: UIView { get }
  var firstResponder: UIView { get }
  var didFirstResponder: Bool { get }
}

extension ProfileContentProtocol where Self: UIView {
  var view: UIView { return self }
}

enum ProfileInputType {
  case text
  case email
  case number
  case mobileNumber
}

class ProfileCell : WebPageMessageCell {
  struct Metric {
    static let viewTop = 20.f
    static let viewLeading = 26.f
    static let viewTrailing = 26.f
    static let viewBottom = 5.f
  }
  
  let profileExtendableView = ProfileExtendableView()
  var topToMessageConstraint: Constraint?
  var topToWebConstraint: Constraint?
  
  override func initialize() {
    super.initialize()
    self.contentView.layer.masksToBounds = false
    self.contentView.addSubview(self.profileExtendableView)
  }
  
  override func setLayouts() {
    super.setLayouts()
    self.profileExtendableView.snp.makeConstraints { [weak self] (make) in
      self?.topToMessageConstraint = make.top.equalTo((self?.textMessageView.snp.bottom)!).offset(Metric.viewTop).constraint
      self?.topToWebConstraint =  make.top.equalTo((self?.webView.snp.bottom)!).offset(Metric.viewTop).priority(750).constraint
      make.left.equalToSuperview().inset(Metric.viewLeading)
      make.right.equalToSuperview().inset(Metric.viewTrailing)
      make.bottom.equalToSuperview().inset(Metric.viewBottom)
    }
  }
  
  override func prepareForReuse() {
    super.prepareForReuse()
  }
  
  override func configure(_ viewModel: MessageCellModelType, presenter: ChatManager? = nil) {
    super.configure(viewModel, presenter: presenter)
    self.profileExtendableView.configure(model: viewModel, presenter: presenter, redraw: presenter?.shouldRedrawProfileBot ?? false)
    if viewModel.message.webPage != nil {
      self.topToMessageConstraint?.deactivate()
      self.topToWebConstraint?.activate()
    } else {
      self.topToMessageConstraint?.activate()
      self.topToWebConstraint?.deactivate()
    }
  }
  
  override class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    var height = super.cellHeight(fits: width, viewModel: viewModel) + 20
    height += ProfileExtendableView.viewHeight(
      fit: width - Metric.viewLeading - Metric.viewTrailing,
      model: viewModel)
    return height
  }
}
