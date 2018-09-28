//
//  SatisfactionCell.swift
//  CHPlugin
//
//  Created by R3alFr3e on 6/20/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SnapKit
import Reusable
import RxSwift

final class SatisfactionFeedbackCell: BaseTableViewCell,Reusable {
  let containerView = UIView()
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 13)
    $0.textColor = CHColors.blueyGrey
    $0.text = CHAssets.localized("ch.review.require.title")
    $0.textAlignment = .center
  }
  
  let exitButton = UIButton().then {
    $0.setImage(CHAssets.getImage(named:"exitG"), for: .normal)
  }
  
  let detailLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 16)
    $0.textColor = CHColors.dark
    $0.text = CHAssets.localized("ch.review.require.description")
    $0.textAlignment = .center
  }
  
  let divider = UIView().then {
    $0.backgroundColor = CHColors.paleGrey
  }
  
  var feedbackSubject = PublishSubject<String>()

  static var reuseIdentifier = "SatisfactionCell"
  
  let disSatisfiedButton = UIButton().then {
    $0.setTitle(CHAssets.localized("ch.review.dislike"), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    $0.setTitleColor(CHColors.blueyGrey, for: .normal)
    $0.setTitleColor(CHColors.warmPink, for: .highlighted)
    $0.setImage(CHAssets.getImage(named: "angryFaceGreySm"), for: .normal)
    $0.setImage(CHAssets.getImage(named: "angryFaceLarge"), for: .highlighted)
    $0.alignVertical(spacing: 5)
  }
  
  let satisfiedButton = UIButton().then {
    $0.setTitle(CHAssets.localized("ch.review.like"), for: .normal)
    $0.titleLabel?.font = UIFont.systemFont(ofSize: 13)
    $0.setTitleColor(CHColors.blueyGrey, for: .normal)
    $0.setTitleColor(CHColors.azure, for: .highlighted)
    $0.setImage(CHAssets.getImage(named: "happyFaceGreySm"), for: .normal)
    $0.setImage(CHAssets.getImage(named: "happyFaceLarge"), for: .highlighted)
    $0.alignVertical(spacing: 5)
  }
  
  override func initialize() {
    super.initialize()
    
    self.containerView.layer.cornerRadius = 6
    self.containerView.layer.shadowColor = CHColors.dark.cgColor
    self.containerView.layer.shadowOpacity = 0.2
    self.containerView.layer.shadowOffset = CGSize(width: 0, height: 2)
    self.containerView.layer.shadowRadius = 3
    self.containerView.layer.borderWidth = 1
    self.containerView.layer.borderColor = CHColors.lightGray.cgColor
    self.containerView.backgroundColor = CHColors.white
    
    self.containerView.addSubview(self.titleLabel)
    self.containerView.addSubview(self.exitButton)
    self.containerView.addSubview(self.detailLabel)
    self.containerView.addSubview(self.divider)
  
    self.containerView.addSubview(self.disSatisfiedButton)
    self.containerView.addSubview(self.satisfiedButton)
    
    self.contentView.addSubview(self.containerView)
    
    self.disSatisfiedButton.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.feedbackSubject.onNext("dislike")
        self?.feedbackSubject.onCompleted()
      }).disposed(by: self.disposeBag)
    
    self.satisfiedButton.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.feedbackSubject.onNext("like")
        self?.feedbackSubject.onCompleted()
      }).disposed(by: self.disposeBag)
    
    self.exitButton.signalForClick()
      .subscribe(onNext: { [weak self] _ in
        self?.feedbackSubject.onNext("")
        self?.feedbackSubject.onCompleted()
      }).disposed(by: self.disposeBag)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.containerView.snp.remakeConstraints { (make) in
      make.top.equalToSuperview().inset(8)
      make.leading.equalToSuperview().inset(10)
      make.trailing.equalToSuperview().inset(10)
      make.bottom.equalToSuperview().inset(8)
    }
    
    self.titleLabel.snp.remakeConstraints { (make) in
      make.top.equalToSuperview().inset(18)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().inset(18)
    }
    
    self.exitButton.snp.remakeConstraints { [weak self] (make) in
      make.size.equalTo(CGSize(width: 24, height: 24))
      make.trailing.equalToSuperview().inset(10)
      make.top.equalToSuperview().inset(10)
      make.leading.equalTo((self?.titleLabel.snp.trailing)!).offset(10)
    }
    
    self.detailLabel.snp.remakeConstraints { [weak self] (make) in
      make.leading.equalToSuperview().inset(20)
      make.trailing.equalToSuperview().inset(20)
      make.top.equalTo((self?.titleLabel.snp.bottom)!).offset(10)
    }
    
    self.divider.snp.remakeConstraints { [weak self] (make) in
      make.height.equalTo(1)
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalTo((self?.satisfiedButton.snp.top)!)
    }
    
    self.satisfiedButton.snp.remakeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(0.4)
      make.height.equalTo(75)
      make.trailing.equalToSuperview().inset(18)
      make.bottom.equalToSuperview()
    }
    
    self.disSatisfiedButton.snp.remakeConstraints { (make) in
      make.width.equalToSuperview().multipliedBy(0.4)
      make.height.equalTo(75)
      make.leading.equalToSuperview().inset(18)
      make.bottom.equalToSuperview()
    }
  }
  
  func signalForFeedback() -> Observable<String> {
    return self.feedbackSubject
  }
  
  class func cellHeight(fits width: CGFloat, viewModel: MessageCellModelType) -> CGFloat {
    return 158 + 16
  }
}
