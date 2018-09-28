//
//  UserChat.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 14..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper
import RxSwift

enum ReviewType: String {
  case like
  case dislike
}

struct CHUserChat: ModelType {
  // ModelType
  var id = ""
  // UserChat
  var personType: String = ""
  var personId: String = ""
  var channelId: String = ""
  var state: String = ""
  var review: String = ""
  var createdAt: Date?
  var openedAt: Date?
  var updatedAt: Date?
  var followedAt: Date?
  var resolvedAt: Date?
  var closedAt: Date?
  var followedBy: String = ""
  var hostId: String?
  var hostType: String?
  
  var appMessageId: String?
  var resolutionTime: Int = 0
  
  var readableUpdatedAt: String {
    if let updatedAt = self.lastMessage?.createdAt {
      return updatedAt.readableTimeStamp()
    }
    return ""
  }
  
  var name: String {
    if let host = self.lastTalkedHost {
      return host.name
    }
    
    return self.channel?.name ?? CHAssets.localized("ch.unknown")
  }

  // Dependencies
  var lastMessage: CHMessage?
  var session: CHSession?
  var lastTalkedHost: CHEntity?
  var channel: CHChannel?
}

extension CHUserChat: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id               <- map["id"]
    personType       <- map["personType"]
    personId         <- map["personId"]
    channelId        <- map["channelId"]
    state            <- map["state"]
    review           <- map["review"]
    createdAt        <- (map["createdAt"], CustomDateTransform())
    openedAt         <- (map["openedAt"], CustomDateTransform())
    followedAt       <- (map["followedAt"], CustomDateTransform())
    resolvedAt       <- (map["resolvedAt"], CustomDateTransform())
    closedAt         <- (map["closedAt"], CustomDateTransform())
    updatedAt        <- (map["appUpdatedAt"], CustomDateTransform())
    followedBy       <- map["followedBy"]
    appMessageId     <- map["appMessageId"]
    hostId           <- map["hostId"]
    hostType         <- map["hostType"]
    
    resolutionTime   <- map["resolutionTime"]
  }
}

//TODO: Refactor to AsyncActionCreator
extension CHUserChat {
  
  static func get(userChatId: String) -> Observable<ChatResponse> {
    return UserChatPromise.getChat(userChatId: userChatId)
  }
  
  static func getChats(since: Int64?=nil, showCompleted: Bool = false) -> Observable<[String: Any?]> {
    return UserChatPromise.getChats(since: since, limit: 30, showCompleted: showCompleted)
  }
  
  static func create(pluginId: String) -> Observable<ChatResponse>{
    return UserChatPromise.createChat(pluginId: pluginId)
  }
  
  func remove() -> Observable<Any?> {
    return UserChatPromise.remove(userChatId: self.id)
  }
  
  func close(closeMessageId: String) -> Observable<CHUserChat> {
    return UserChatPromise.close(userChatId: self.id, formId: closeMessageId)
  }
  
  func review(reviewMessageId: String, rating: ReviewType) -> Observable<CHUserChat> {
    return UserChatPromise.review(userChatId: self.id, formId: reviewMessageId, rating: rating)
  }
  
  func read(at message: CHMessage?) {
    guard let message = message else { return }
    guard let session = self.session else { return }
    guard session.unread != 0 || session.alert != 0 else { return }
    
    _ = UserChatPromise.setMessageRead(userChatId: self.id, at: message.createdAt)
      .subscribe(onNext: { (_) in
        self.readAllManually()
      }, onError: { (error) in
        
      })
  }
  
  func read(at message: CHMessage) -> Observable<Bool> {
    return Observable.create({ (subscriber) in
      let signal = UserChatPromise.setMessageRead(userChatId: self.id, at: message.createdAt)
        .subscribe(onNext: { (_) in
          self.readAllManually()
          subscriber.onNext(true)
          subscriber.onCompleted()
        }, onError: { (error) in
          subscriber.onNext(false)
          subscriber.onCompleted()
        })
      
      return Disposables.create {
        signal.dispose()
      }
    })
  }
  
  func readAllManually() {
    guard var session = self.session else { return }
    session.unread = 0
    session.alert = 0
    mainStore.dispatch(UpdateSession(payload: session))
  }
}

extension CHUserChat {
  func isActive() -> Bool {
    return self.state != "closed" && self.state != "solved" && self.state != "removed"
  }
  
  func isClosed() -> Bool {
    return self.state == "closed"
  }
  
  func isRemoved() -> Bool {
    return self.state == "removed"
  }
  
  func isSolved() -> Bool {
    return self.state == "solved"
  }
  
  func isCompleted() -> Bool {
    return self.state == "closed" || self.state == "solved" || self.state == "removed"
  }
  
  func isReadyOrOpen() -> Bool {
    return self.state == "ready" || self.state == "open"
  }
  
  func isOpen() -> Bool {
    return self.state == "open"
  }
  
  func isEngaged() -> Bool {
    return self.state == "solved" || self.state == "closed" || self.state == "following"
  }
  
  static func becomeActive(current: CHUserChat?, next: CHUserChat?) -> Bool {
    guard let current = current, let next = next else { return false }
    return current.isReadyOrOpen() && !next.isReadyOrOpen()
  }
  
  static func becomeOpen(current: CHUserChat?, next: CHUserChat?) -> Bool {
    guard let current = current, let next = next else { return false }
    return current.isSolved() && next.isReadyOrOpen()
  }
}

extension CHUserChat: Equatable {
  static func ==(lhs: CHUserChat, rhs: CHUserChat) -> Bool {
    return lhs.id == rhs.id &&
      lhs.session?.alert == rhs.session?.alert &&
      lhs.state == rhs.state &&
      lhs.lastMessage == rhs.lastMessage
  }
}

