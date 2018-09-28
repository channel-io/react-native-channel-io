//
//  MessagesSelector.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ReSwift

func messagesSelector(state: AppState, userChatId: String?) -> [CHMessage] {
  guard let userChatId = userChatId else { return [] }
  
  let messages: [CHMessage] = state.messagesState
    .findBy(userChatId: userChatId)
    .map({
      return CHMessage(
        id: $0.id,
        channelId: $0.channelId,
        chatType: $0.chatType,
        chatId: $0.chatId,
        personType: $0.personType,
        personId: $0.personId,
        title: $0.title,
        message: $0.message,
        messageV2: $0.messageV2,
        requestId: $0.requestId,
        botOption: $0.botOption,
        profileBot: $0.profileBot,
        form: $0.form,
        submit: $0.submit,
        createdAt: $0.createdAt,
        language: $0.language,
        translateState: $0.translateState,
        translatedText: $0.translatedText,
        file: $0.file,
        webPage: $0.webPage,
        log: $0.log,
        entity: personSelector(state: state, personType: $0.personType, personId: $0.personId),
        state: $0.state,
        messageType: $0.messageType,
        progress: $0.progress,
        onlyEmoji: $0.onlyEmoji
      )
    }).sorted(by: { (m1, m2) -> Bool in
      return m1.createdAt > m2.createdAt
    })

  return LocalMessageFactory.generate(
    type: .DateDivider,
    messages: messages,
    userChat: nil)
}

func messageSelector(state: AppState, id: String?) -> CHMessage? {
  guard let id = id else { return nil }
  
  let message: CHMessage! = state.messagesState
    .findBy(id: id)
    .map({
      return CHMessage(
        id: $0.id,
        channelId: $0.channelId,
        chatType: $0.chatType,
        chatId: $0.chatId,
        personType: $0.personType,
        personId: $0.personId,
        title: $0.title,
        message: $0.message,
        messageV2: $0.messageV2,
        requestId: $0.requestId,
        botOption: $0.botOption,
        profileBot: $0.profileBot,
        form: $0.form,
        submit: $0.submit,
        createdAt: $0.createdAt,
        language: $0.language,
        translateState: $0.translateState,
        translatedText: $0.translatedText,
        file: $0.file,
        webPage: $0.webPage,
        log: $0.log,
        entity: personSelector(state: state, personType: $0.personType, personId: $0.personId),
        state: $0.state,
        messageType: $0.messageType,
        progress: $0.progress,
        onlyEmoji: $0.onlyEmoji
      )
    })
  
  return message
}
