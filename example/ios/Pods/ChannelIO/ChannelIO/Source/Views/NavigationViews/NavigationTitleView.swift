//
//  NavigationTitleView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 23/11/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class NavigationTitleView : BaseView {
  let contentView = UIView()
  
  let statusImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named:"fastW")
    $0.contentMode = .center
    $0.alpha = 0
  }
  
  let titleLabel = UILabel().then {
    $0.font = UIFont.boldSystemFont(ofSize: 17)
    $0.textAlignment = .center
    $0.numberOfLines = 1
  }
  
  let toggleImageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "dropdownTriangle")?.withRenderingMode(.alwaysTemplate)
    $0.contentMode = .center
    $0.transform = $0.transform.scaledBy(x: 1, y: -1)
  }
  
  let subtitleLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 11)
    $0.textAlignment = .center
    $0.alpha = 0
    //textColor based on plugin
  }

  let statusChangeSubject = PublishSubject<Bool>()
  var titleTopContraint: Constraint? = nil
  
  let disposeBag = DisposeBag()

  var isExpanded = true {
    willSet {
      if newValue != self.isExpanded {
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
          self?.expand(with: newValue ? 1 : 0)
        })
      }
    }
  }
  
  override func initialize() {
    super.initialize()

    self.addSubview(self.statusImageView)
    self.addSubview(self.titleLabel)
    self.addSubview(self.toggleImageView)
    self.addSubview(self.subtitleLabel)
    //self.addSubview(self.contentView)
    
    self.signalForClick()
      .subscribe { [weak self] (_) in
        guard let s = self else { return }
        s.isExpanded = !s.isExpanded
        s.statusChangeSubject.onNext(s.isExpanded)
        
        UIView.animate(withDuration: 0.2, animations: {
          s.layoutIfNeeded()
        })
      }.disposed(by: self.disposeBag)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.statusImageView.snp.makeConstraints { [weak self] (make) in
      make.leading.greaterThanOrEqualToSuperview().inset(5)
      make.trailing.equalTo((self?.titleLabel.snp.leading)!)
      make.centerY.equalTo((self?.titleLabel.snp.centerY)!)
      make.height.equalTo(22)
      make.width.equalTo(22)
    }
    
    self.titleLabel.snp.makeConstraints { [weak self] (make) in
      self?.titleTopContraint = make.top.equalToSuperview().inset(11).constraint
      make.centerX.equalToSuperview()
    }
    
    self.toggleImageView.snp.makeConstraints { [weak self] (make) in
      make.trailing.lessThanOrEqualToSuperview().inset(5)
      make.leading.equalTo((self?.titleLabel.snp.trailing)!)
      make.centerY.equalTo((self?.titleLabel.snp.centerY)!)
      make.height.equalTo(22)
      make.width.equalTo(22)
    }
    
    self.subtitleLabel.snp.makeConstraints { [weak self] (make) in
      make.top.equalTo((self?.titleLabel.snp.bottom)!)
      make.centerX.equalToSuperview()
      make.leading.greaterThanOrEqualToSuperview().inset(5)
      make.trailing.lessThanOrEqualToSuperview().inset(5)
    }
  }
  
  func configure(channel: CHChannel, userChat: CHUserChat?, plugin: CHPlugin) {
    self.titleLabel.textColor = plugin.textUIColor
    self.subtitleLabel.textColor = plugin.textUIColor
    
    if let host = userChat?.lastTalkedHost {
      self.configureForFollow(host: host, plugin: plugin)
    } else if !channel.working {
      self.configureForOff(channel: channel, plugin: plugin)
    } else {
      self.configureForReady(channel: channel, plugin: plugin)
    }
  }
  
  fileprivate func configureForOff(channel: CHChannel, plugin: CHPlugin) {
    self.titleLabel.fadeTransition(0.4)
    self.titleLabel.text = channel.name
    self.subtitleLabel.text = CHAssets.localized("ch.chat.expect_response_delay.out_of_working.short_description")
    self.subtitleLabel.isHidden = false
    
    self.statusImageView.image = plugin.textColor == "white" ?
      CHAssets.getImage(named: "offhoursW") :
      CHAssets.getImage(named: "offhoursB")
    self.statusImageView.isHidden = false
  }
  
  fileprivate func configureForFollow(host: CHEntity, plugin: CHPlugin){
    self.titleLabel.fadeTransition(0.4)
    self.titleLabel.text = host.name
    
    if let manager = host as? CHManager, manager.online {
      self.statusImageView.isHidden = false
    } else {
      self.statusImageView.isHidden = true
    }
    
    self.statusImageView.image = plugin.textColor == "white" ?
      CHAssets.getImage(named: "normalW") :
      CHAssets.getImage(named: "normalB")
    
    self.subtitleLabel.isHidden = !(host is CHManager)
    if let manager = host as? CHManager {
      self.titleTopContraint?.update(inset: manager.desc == "" ? 11 : 5)
      self.subtitleLabel.text = manager.desc
    }
  }
  
  fileprivate func configureForReady(channel: CHChannel, plugin: CHPlugin){
    self.titleLabel.fadeTransition(0.4)
    self.titleLabel.text = channel.name
    self.statusImageView.isHidden = false
    self.statusImageView.image = plugin.textColor == "white" ?
      CHAssets.getImage(named: "\(channel.expectedResponseDelay)W") :
      CHAssets.getImage(named: "\(channel.expectedResponseDelay)B")
    
    self.subtitleLabel.text = CHAssets.localized("ch.chat.expect_response_delay.\(channel.expectedResponseDelay).short_description")
    self.subtitleLabel.isHidden = false
  }
  
  func expand(with progress: CGFloat) {
    var progress = progress
    if progress < 0 {
      progress = 0
    } else if progress > 1 {
      progress = 1
    }
    
    if !self.subtitleLabel.isHidden && self.subtitleLabel.text != "" {
      self.titleTopContraint?.update(inset: 5 + progress * 6)
    }
    
    self.statusImageView.alpha = 1 - progress
    self.subtitleLabel.alpha = 0.6 - (progress * 0.6)
    self.toggleImageView.transform = CGAffineTransform(rotationAngle: .pi * progress)
  }
  
  func signalForChange() -> Observable<Bool> {
    return self.statusChangeSubject
  }
  
  override var intrinsicContentSize: CGSize {
    return UILayoutFittingExpandedSize
  }
  
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    let titleWidth = self.titleLabel.text?.width(with: UIFont.boldSystemFont(ofSize: 17)) ?? 0
    let subTitleWidth = self.subtitleLabel.text?.width(with: UIFont.systemFont(ofSize: 11)) ?? 0
    let width = 22 + max(titleWidth, subTitleWidth) + 22 + 10
    return CGSize(width: width, height: 44)
  }
}
