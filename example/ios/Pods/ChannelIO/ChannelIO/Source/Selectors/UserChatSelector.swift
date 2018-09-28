//
//  UserChatSelector.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ReSwift

func userChatsSelector(state: AppState, showCompleted:Bool = false) -> [CHUserChat] {
  var userChats = state.userChatsState.userChats.values.sorted { (c1, c2) -> Bool in
    if let m1Last = c1.lastMessage, let m2Last = c2.lastMessage {
      return m1Last.createdAt > m2Last.createdAt
    }
    return c1.updatedAt! > c2.updatedAt!
  }.filter ({ $0.state != "removed" && $0.appMessageId != nil })
  
  if !showCompleted {
    userChats = userChats.filter({ (userChat) in
      return !userChat.isClosed()
    })
  }
  
  return userChats.map({ (userChat) in
    return CHUserChat(
      id: userChat.id,
      personType: userChat.personType,
      personId: userChat.personId,
      channelId: userChat.channelId,
      state: userChat.state,
      review: userChat.review,
      createdAt: userChat.createdAt,
      openedAt: userChat.openedAt,
      updatedAt: userChat.updatedAt,
      followedAt: userChat.followedAt,
      resolvedAt: userChat.resolvedAt,
      closedAt: userChat.closedAt,
      followedBy: userChat.followedBy,
      hostId: userChat.hostId,
      hostType: userChat.hostType,
      appMessageId: userChat.appMessageId,
      resolutionTime: userChat.resolutionTime,
      lastMessage: state.messagesState.findBy(id: userChat.appMessageId),
      session: state.sessionsState.findBy(userChatId: userChat.id),
      lastTalkedHost: personSelector(state: state, personType: userChat.hostType, personId: userChat.hostId),
      channel: state.channel
    )
  })
}

func userChatSelector(state: AppState, userChatId: String?) -> CHUserChat? {
  guard let userChat = state.userChatsState.findBy(id: userChatId) else {
    return nil
  }
  
  return CHUserChat(
    id: userChat.id,
    personType: userChat.personType,
    personId: userChat.personId,
    channelId: userChat.channelId,
    state: userChat.state,
    review: userChat.review,
    createdAt: userChat.createdAt,
    openedAt: userChat.openedAt,
    updatedAt: userChat.updatedAt,
    followedAt: userChat.followedAt,
    resolvedAt: userChat.resolvedAt,
    closedAt: userChat.closedAt,
    followedBy: userChat.followedBy,
    hostId: userChat.hostId,
    hostType: userChat.hostType,
    appMessageId: userChat.appMessageId,
    resolutionTime: userChat.resolutionTime,
    lastMessage: state.messagesState.findBy(id: userChat.appMessageId),
    session: state.sessionsState.findBy(userChatId: userChat.id),
    lastTalkedHost: personSelector(state: state, personType: userChat.hostType, personId: userChat.hostId),
    channel: state.channel
  )
}
