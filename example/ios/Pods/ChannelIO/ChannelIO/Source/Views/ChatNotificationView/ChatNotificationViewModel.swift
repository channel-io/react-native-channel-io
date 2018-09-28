//
//  ChatNotificationViewModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 2..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation

protocol ChatNotificationViewModelType {
  var message: NSAttributedString? { get }
  var name: String? { get }
  var timestamp: String? { get }
  var avatar: CHEntity? { get }
}

struct ChatNotificationViewModel: ChatNotificationViewModelType {
  var message: NSAttributedString?
  var name: String?
  var timestamp: String?
  var avatar: CHEntity?

  init(push: CHPush) {
    if push.isReviewLog {
      self.name = CHAssets.localized("ch.review.require.title")
      self.avatar = ReviewAvatar()
    } else if let managerName = push.manager?.name {
      self.name = managerName
      self.avatar = push.manager
    } else if let botName = push.bot?.name {
      self.name = botName
      self.avatar = push.bot
    }
    
    if let logMessage = push.message?.logMessage {
      let attributedText = NSMutableAttributedString(string: logMessage)
      attributedText.addAttributes(
        [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14),
         NSAttributedStringKey.foregroundColor: CHColors.charcoalGrey],
        range: NSRange(location: 0, length: logMessage.count))
      self.message = attributedText
    } else {
      self.message = push.message?.messageV2
    }

    self.timestamp = push.message?.readableCreatedAt
  }
}
