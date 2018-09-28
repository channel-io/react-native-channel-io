//
//  ChatStatusFollowedView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 23/11/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import UIKit
import SnapKit

class ChatStatusFollowedView : BaseView {
  let avatarView = AvatarView().then {
    $0.showBorder = false
    $0.showOnline = true
    $0.borderColor = UIColor(mainStore.state.plugin.color)
    $0.alpha = 0
  }
  
  let managerDescLabel = UILabel().then {
    $0.font = UIFont.systemFont(ofSize: 13)
    $0.numberOfLines = 1
    //text color depends on plugin color
  }
  
  var descTopConstraint: Constraint? = nil
  var descBottomContraint: Constraint? = nil
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.avatarView)
    self.addSubview(self.managerDescLabel)
  }
  
  override func setLayouts() {
    super.setLayouts()
    
    self.avatarView.snp.makeConstraints { (make) in
      make.top.equalToSuperview()
      make.height.equalTo(44)
      make.width.equalTo(44)
      make.centerX.equalToSuperview()
    }
    
    self.managerDescLabel.snp.makeConstraints { [weak self] (make) in
      self?.descTopConstraint = make.top.equalTo((self?.avatarView.snp.bottom)!).offset(7).constraint
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().inset(30)
      make.trailing.equalToSuperview().inset(30)
      make.bottom.equalToSuperview().inset(20)
    }
  }
  
  func configure(lastTalkedHost: CHEntity?, channel: CHChannel, plugin: CHPlugin) {
    self.backgroundColor = UIColor(plugin.color)
    
    if let host = lastTalkedHost {
      self.avatarView.configure(host)
      self.descTopConstraint?.update(inset: 0)
    } else {
      self.avatarView.configure(channel)
      self.descTopConstraint?.update(inset: 0)
    }
    
    //self.managerDescLabel.text = manager?.desc ?? ""
    self.managerDescLabel.textColor = plugin.textUIColor
    self.animatedAvatarIfNeeded()
  }
  
  func animatedAvatarIfNeeded() {
    guard self.avatarView.alpha == 0 else { return }
    self.avatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    UIView.animate(withDuration: 0.4, delay: 0.0, options: .curveEaseOut, animations: {
      self.avatarView.alpha = 1
      self.avatarView.transform = CGAffineTransform.identity
    }, completion: nil)
  }
  
  static func viewHeight(host: CHEntity?) -> CGFloat {
    if let manager = host as? CHManager, manager.desc != "" {
      return 90
    }
    return 66
  }
}
