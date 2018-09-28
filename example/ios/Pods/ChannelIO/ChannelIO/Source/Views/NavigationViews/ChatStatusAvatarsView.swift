//
//  ChatStatusAvatarsView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 05/12/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import UIKit
import SnapKit

class ChatStatusAvatarsView: BaseView {
  let firstAvatarView = AvatarView().then {
    $0.avatarSize = 46
    $0.showBorder = true
    $0.showOnline = false
    $0.borderColor = UIColor(mainStore.state.plugin.color)
    $0.alpha = 0
  }
  let secondAvatarView = AvatarView().then {
    $0.avatarSize = 46
    $0.showBorder = true
    $0.showOnline = false
    $0.borderColor = UIColor(mainStore.state.plugin.color)
    $0.alpha = 0
  }
  let thirdAvatarView = AvatarView().then {
    $0.avatarSize = 46
    $0.showBorder = true
    $0.showOnline = false 
    $0.borderColor = UIColor(mainStore.state.plugin.color)
    $0.alpha = 0
  }
  
  var persons = [CHEntity]()
  
  var avatarSize: CGFloat = 46
  var coverMargin: CGFloat = 6
  
  var firstTrailingContraint: Constraint? = nil
  var secondLeadingConstraint: Constraint? = nil
  var secondTrailingContraint: Constraint? = nil
  var thirdLeadingConstraint: Constraint? = nil
  var widthConstraint: Constraint? = nil
  
  //add property to reuse
  init(avatarSize: CGFloat = 0, coverMargin: CGFloat = 0) {
    self.avatarSize = avatarSize
    self.coverMargin = coverMargin
    super.init(frame: CGRect.zero)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func initialize() {
    super.initialize()
    
    self.addSubview(self.thirdAvatarView)
    self.addSubview(self.secondAvatarView)
    self.addSubview(self.firstAvatarView)
  }
  
  override func setLayouts() {
    super.setLayouts()

    self.snp.makeConstraints { [weak self] (make) in
      self?.widthConstraint = make.width.equalTo(46).constraint
    }

    self.firstAvatarView.snp.remakeConstraints { [weak self] (make) in
      guard let s = self else { return }
      make.size.equalTo(CGSize(width:s.avatarSize, height:s.avatarSize)).priority(750)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.leading.equalToSuperview()
      s.firstTrailingContraint = make.trailing.equalToSuperview().constraint
    }
    
    self.secondAvatarView.snp.remakeConstraints { [weak self] (make) in
      guard let s = self else { return }
      make.size.equalTo(CGSize(width:s.avatarSize, height:s.avatarSize)).priority(750)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      s.secondTrailingContraint = make.trailing.equalToSuperview().constraint
      s.secondLeadingConstraint = make.leading.equalToSuperview().inset(s.avatarSize - s.coverMargin).constraint
    }
    
    self.thirdAvatarView.snp.remakeConstraints { [weak self] (make) in
      guard let s = self else { return }
      make.size.equalTo(CGSize(width:s.avatarSize, height:s.avatarSize)).priority(750)
      make.top.equalToSuperview()
      make.bottom.equalToSuperview()
      make.trailing.equalToSuperview()
      s.thirdLeadingConstraint = make.leading.equalToSuperview().inset(s.avatarSize * 2 - s.coverMargin * 2).constraint
    }
  }
  
  func configure(persons: [CHEntity]) {
    guard self.isIdentical(persons: persons) == false else { return }
    self.persons = persons
    
    self.isHidden = persons.count == 0
    if persons.count == 1 {
      self.firstAvatarView.configure(persons[0])
      self.firstTrailingContraint?.activate()
      self.secondLeadingConstraint?.deactivate()
      self.secondTrailingContraint?.activate()
      self.thirdLeadingConstraint?.deactivate()
      self.widthConstraint?.update(offset: self.avatarSize)
      self.layoutOneAvatar()
    } else if persons.count == 2 {
      self.firstAvatarView.configure(persons[0])
      self.secondAvatarView.configure(persons[1])
      self.firstTrailingContraint?.deactivate()
      self.secondLeadingConstraint?.activate()
      self.secondTrailingContraint?.activate()
      self.thirdLeadingConstraint?.deactivate()
      self.widthConstraint?.update(offset: self.avatarSize * 2 - self.coverMargin)
      self.layoutTwoAvatars()
    } else if persons.count >= 3 {
      self.firstAvatarView.configure(persons[0])
      self.secondAvatarView.configure(persons[1])
      self.thirdAvatarView.configure(persons[2])
      self.firstTrailingContraint?.deactivate()
      self.secondLeadingConstraint?.activate()
      self.secondTrailingContraint?.deactivate()
      self.thirdLeadingConstraint?.activate()
      self.widthConstraint?.update(offset: self.avatarSize * 3 - self.coverMargin * 2)
      self.layoutThreeAvatars()
    }
  }
  
  func isIdentical(persons: [CHEntity]) -> Bool {
    for person in persons {
      if self.persons.index(where: { (p) in
        return p.avatarUrl == person.avatarUrl && p.name == person.name
      }) != nil {
        continue
      } else {
        return false
      }
    }
    
    return true
  }
  
  func layoutOneAvatar() {
    self.firstAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    self.secondAvatarView.alpha = 0
    self.thirdAvatarView.alpha = 0
    
    UIView.animateKeyframes(withDuration: 0.51, delay: 0.2, options: UIViewKeyframeAnimationOptions.calculationModePaced, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.21, relativeDuration: 0.3, animations: {
        self.firstAvatarView.alpha = 1
        self.firstAvatarView.transform = CGAffineTransform.identity
      })
    }) { (_) in
      
    }
  }
  
  func layoutTwoAvatars() {
    self.firstAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    self.secondAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    self.thirdAvatarView.alpha = 0
    
    UIView.animateKeyframes(withDuration: 0.51, delay: 0.2, options: UIViewKeyframeAnimationOptions.calculationModePaced, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.18, relativeDuration: 0.3, animations: {
        self.secondAvatarView.alpha = 1
        self.secondAvatarView.transform = CGAffineTransform.identity
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.21, relativeDuration: 0.3, animations: {
        self.firstAvatarView.alpha = 1
        self.firstAvatarView.transform = CGAffineTransform.identity
      })
    }) { (_) in
      
    }
  }
  
  func layoutThreeAvatars() {
    self.firstAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    self.secondAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    self.thirdAvatarView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
    
    UIView.animateKeyframes(withDuration: 0.8, delay: 0.2, options: UIViewKeyframeAnimationOptions.beginFromCurrentState, animations: {
      UIView.addKeyframe(withRelativeStartTime: 0.15, relativeDuration: 0.3, animations: {
        self.thirdAvatarView.alpha = 1
        self.thirdAvatarView.transform = CGAffineTransform.identity
      })
      
      UIView.addKeyframe(withRelativeStartTime: 0.35, relativeDuration: 0.25, animations: {
        self.secondAvatarView.alpha = 1
        self.secondAvatarView.transform = CGAffineTransform.identity
      })

      UIView.addKeyframe(withRelativeStartTime: 0.59, relativeDuration: 0.21, animations: {
        self.firstAvatarView.alpha = 1
        self.firstAvatarView.transform = CGAffineTransform.identity
      })
    }) { (_) in
      
    }
  }
}
