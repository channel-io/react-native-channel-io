//
//  UserChatCellModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation

protocol UserChatCellModelType {
  var title: String { get }
  var lastMessage: String? { get }
  var timestamp: String { get }
  var avatar: CHEntity? { get }
  var badgeCount: Int { get }
  var isBadgeHidden: Bool { get }
  var isClosed: Bool { get }
}

struct UserChatCellModel: UserChatCellModelType {
  let title: String
  let lastMessage: String?
  let timestamp: String
  let avatar: CHEntity?
  let badgeCount: Int
  let isBadgeHidden: Bool
  let isClosed: Bool
  
  init(userChat: CHUserChat) {
    self.title = userChat.name
    if userChat.state == "closed" && userChat.review != "" {
      self.lastMessage = CHAssets.localized("ch.review.complete.preview")
    } else if let logMessage = userChat.lastMessage?.logMessage {
      self.lastMessage = logMessage
    } else {
      self.lastMessage = userChat.lastMessage?.messageV2?.string ?? ""
    }

    self.timestamp = userChat.readableUpdatedAt
    self.avatar = userChat.lastTalkedHost ?? mainStore.state.channel
    self.badgeCount = userChat.session?.alert ?? 0
    self.isBadgeHidden = self.badgeCount == 0
    self.isClosed = userChat.isClosed()
  }
  
}
