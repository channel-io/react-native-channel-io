//
//  WsService.swift
//  CHPlugin
//
//  Created by Haeun Chung on 10/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SwiftyJSON
import RxSwift
import ReSwift
import SocketIO
import ObjectMapper

enum WSType: String {
  case PRODUCTION = "https://ws.channel.io"
  case ALPHA = "http://ws.exp.channel.io"
  case BETA = "http://ws.staging.channel.io"
}

enum CHSocketRequest : String {
  case authentication = "authentication"
  case join = "join"
  case leave = "leave"
  case heartbeat = "heartbeat"
  
  var value: String {
    return self.rawValue
  }
}

enum CHSocketResponse : String {
  case connected = "connect"
  case ready = "ready"
  case create = "create"
  case update = "update"
  case delete = "delete"
  case joined = "joined"
  case leaved = "leaved"
  case authenticated = "authenticated"
  case unauthorized = "unauthorized"
  case reconnect = "reconnectAttempt"
  case disconnect = "disconnect"
  case push = "push"
  case error = "error"
  case typing = "typing"
  
  var value: String {
    return self.rawValue
  }
}

struct WsServiceType: OptionSet {
  // event
  static let Create = WsServiceType(rawValue: 1 << 1)
  static let Update = WsServiceType(rawValue: 1 << 2)
  static let Delete = WsServiceType(rawValue: 1 << 3)
  
  // model
  static let Message = WsServiceType(rawValue: 1 << 4)
  static let Session = WsServiceType(rawValue: 1 << 5)
  static let Manager = WsServiceType(rawValue: 1 << 6)
  static let Channel = WsServiceType(rawValue: 1 << 7)
  static let UserChat = WsServiceType(rawValue: 1 << 8)
  static let Veil = WsServiceType(rawValue: 1 << 9)
  static let User = WsServiceType(rawValue: 1 << 10)
  
  static let CreateMessage = WsServiceType.Create.union(WsServiceType.Message)
  static let UpdateMessage = WsServiceType.Update.union(WsServiceType.Message)
  static let DeleteMessage = WsServiceType.Delete.union(WsServiceType.Message)
  
  static let CreateSession = WsServiceType.Create.union(WsServiceType.Session)
  static let UpdateSession = WsServiceType.Update.union(WsServiceType.Session)
  static let DeleteSession = WsServiceType.Delete.union(WsServiceType.Session)
  
  static let UpdateManager = WsServiceType.Update.union(WsServiceType.Manager)
  static let UpdateChannel = WsServiceType.Update.union(WsServiceType.Channel)
  
  static let CreateUserChat = WsServiceType.Create.union(WsServiceType.UserChat)
  static let UpdateUserChat = WsServiceType.Update.union(WsServiceType.UserChat)
  static let DeleteUserChat = WsServiceType.Delete.union(WsServiceType.UserChat)
  
  static let UpdateUser = WsServiceType.Update.union(WsServiceType.User)
  static let UpdateVeil = WsServiceType.Update.union(WsServiceType.Veil)
  
  let rawValue: Int
  init(rawValue: Int) { self.rawValue = rawValue }
  
  init?(string: String) {
    switch string {
    // event
    case "Create": self = WsServiceType.Create
    case "Update": self = WsServiceType.Update
    case "Delete": self = WsServiceType.Delete
    // type
    case "Message": self = WsServiceType.Message
    case "Session": self = WsServiceType.Session
    case "Manager": self = WsServiceType.Manager
    case "Channel": self = WsServiceType.Channel
    case "UserChat": self = WsServiceType.UserChat
    case "Veil": self = WsServiceType.Veil
    case "User" : self = WsServiceType.User
      
    default: return nil
    }
  }
}

class WsService {
  //MARK: Share Singleton Instance
  static let shared = WsService()
  let eventSubject = PublishSubject<(WsServiceType, Any?)>()
  let readySubject = PublishSubject<String>()
  let typingSubject = PublishSubject<CHTypingEntity>()
  let joinSubject = PublishSubject<String>()
  let messageOnCreateSubject = PublishSubject<CHMessage>()
  let errorSubject = PublishSubject<Any?>()
  
  //MARK: Private properties
  fileprivate var socket: SocketIOClient?
  fileprivate var manager: SocketManager?
  
  var baseUrl = WSType.PRODUCTION.rawValue
  
  //move these properties into state
  fileprivate var currentChatId: String?
  fileprivate var currentChat: CHUserChat?
  fileprivate var heartbeatTimer: Timer?
  
  private var queue = DispatchQueue(label: "channel.websocket", qos: .background)
  
  private var stopTypingThrottleFnc: ((CHUserChat?) -> Void)?
  private var startTypingThrottleFnc: ((CHUserChat?) -> Void)?
  
  init() {
    if let staging = CHUtils.getCurrentStage() {
      if staging == "PROD" {
        self.baseUrl = WSType.PRODUCTION.rawValue
      } else if staging == "ALPHA" {
        self.baseUrl = WSType.ALPHA.rawValue
      } else if staging == "BETA" {
        self.baseUrl = WSType.BETA.rawValue
      } else {
        // error
      }
    }
    
    self.stopTypingThrottleFnc = throttle(
      delay: 1.0,
      queue: queue,
      action: self.stopTyping)
    
    self.startTypingThrottleFnc = throttle(
      delay: 1.0,
      queue: queue,
      action: self.startTyping)
  }
  
  //MARK: Signals 
  
  //TODO: update to <String, Any?> to receive data
  func listen() -> PublishSubject<(WsServiceType, Any?)> {
    return self.eventSubject
  }
  
  func ready() -> PublishSubject<String> {
    return self.readySubject
  }
  
  func typing() -> PublishSubject<CHTypingEntity> {
    return self.typingSubject
  }
  
  func mOnCreate() -> PublishSubject<CHMessage> {
    return self.messageOnCreateSubject
  }
  
  func joined() -> PublishSubject<String> {
    return self.joinSubject
  }
  
  func error() -> Observable<Any?> {
    return self.errorSubject.asObserver()
  }
  
  //MARK: Socket functionalities
  
  func connect() {
    dlog("Try to connect Socket")
    
    self.disconnect()
    
    self.manager = SocketManager(
      socketURL: URL(string: "\(self.baseUrl)")!,
      config: [
        .log(false),
        .forceWebsockets(true),
        .forcePolling(true),
        .reconnectAttempts(5),
        .reconnectWait(10)
      ])

    self.socket = self.manager?.socket(forNamespace: "/app")
    self.socket?.removeAllHandlers()
    self.addSocketHandlers()
    self.socket?.connect()
  }
  
  func disconnect() {
    if self.socket != nil {
      self.socket?.removeAllHandlers()
      self.socket?.disconnect()
      self.socket = nil
      self.invalidateTimer()
      dlog("socket disconnect manually")
    }
  }
  
  /*
    Join and Leave is not restricted to use 
    but we intend to use it for only one userChat
  */
  func join(chatId: String?) {
    guard let chatId = chatId, chatId != "" else { return }
    
    self.currentChatId = chatId
    self.socket?.emit(CHSocketRequest.join.value, "/user_chats/\(chatId)")
  }
  
  func leave(chatId: String?) {
    guard let chatId = chatId, chatId != "" else { return }
    
    self.currentChatId = ""
    self.socket?.emit(CHSocketRequest.leave.value, "/user_chats/\(chatId)")
  }
  
  func sendTyping(chat: CHUserChat?, isStop: Bool) {
    guard let socket = self.socket, socket.status == .connected else { return }
    guard let chat = chat else { return }
    
    if isStop {
      self.stopTypingThrottleFnc?(chat)
    } else {
      self.startTypingThrottleFnc?(chat)
    }
  }
  
  func startTyping(chat: CHUserChat?) {
    guard let socket = self.socket, socket.status == .connected else { return }
    guard let chat = chat else { return }
    socket.emit("typing", CHTypingEntity(
      action: "start",
      chatId: chat.id,
      chatType: "UserChat")
    )
  }
  
  func stopTyping(chat: CHUserChat?) {
    guard let socket = self.socket, socket.status == .connected else { return }
    guard let chat = chat else { return }
    
    let entity = CHTypingEntity(
      action: "stop",
      chatId: chat.id,
      chatType: "UserChat")
    
    socket.emit("typing", entity)
    self.typingSubject.onNext(entity)
  }
  
  @objc func heartbeat() {
    dlog("heartbeat")
    if self.socket != nil {
      self.socket?.emit(CHSocketRequest.heartbeat.value)
    } else {
      self.invalidateTimer()
    }
  }
  
  func invalidateTimer() {
    if self.heartbeatTimer != nil {
      self.heartbeatTimer!.invalidate()
      self.heartbeatTimer = nil
    }
  }
}

//MARK: Socket IO Handlers
fileprivate extension WsService {
  fileprivate func addSocketHandlers() {
    self.onCreate()
    self.onConnect()
    self.onReady()
    self.onUpdate()
    self.onDelete()
    self.onJoined()
    self.onLeaved()
    self.onPush()
    self.onTyping()
    self.onAuthenticated()
    self.onUnauthorized()
    self.onReconnectAttempt()
    self.onDisconnect()
    self.onError()
  }
  
  fileprivate func onConnect() {
    self.socket?.on(CHSocketResponse.connected.value) { [weak self] (data, ack) in
      dlog("socket connected")
      mainStore.dispatchOnMain(SocketConnected())
      self?.emitAuth()
    }
  }
  
  fileprivate func onReady() {
    self.socket?.on(CHSocketResponse.ready.value) { [weak self] (data, ack) in
      self?.readySubject.onNext(CHSocketResponse.ready.value)
      mainStore.dispatchOnMain(SocketReady())
      dlog("socket ready")
      
      if let chatId = self?.currentChatId {
        self?.join(chatId: chatId)
      }
    }
  }
  
  fileprivate func onCreate() {
    self.socket?.on(CHSocketResponse.create.value) { [weak self] (data, ack) in
      dlog("socket on created")
      guard let data = data.get(index: 0) else { return }
      guard let json = JSON(rawValue: data) else { return }
      guard var type = WsServiceType(string: json["type"].stringValue) else { return }
      type = WsServiceType.Create.union(type)
      
      switch type {
      case WsServiceType.CreateSession:
        guard let session = Mapper<CHSession>()
          .map(JSONObject: json["entity"].object) else { return }
        if let manager = Mapper<CHManager>()
          .map(JSONObject: json["refers"]["manager"].object) {
          mainStore.dispatchOnMain(UpdateManager(payload: manager))
        }
        
        mainStore.dispatchOnMain(CreateSession(payload: session))
        self?.eventSubject.onNext((type, session))
      case WsServiceType.CreateUserChat:
        guard let userChat = Mapper<CHUserChat>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(CreateUserChat(payload: userChat))
        self?.eventSubject.onNext((type, userChat))
      case WsServiceType.CreateMessage:
        guard let message = Mapper<CHMessage>()
          .map(JSONObject: json["entity"].object) else { return }
        guard message.isWelcome == false else { return }
        
        if let bot = Mapper<CHBot>()
          .map(JSONObject: json["refers"]["bot"].object) {
          mainStore.dispatchOnMain(GetBot(payload: bot))
        }
        
        self?.messageOnCreateSubject.onNext(message)
        mainStore.dispatchOnMain(CreateMessage(payload: message))
        self?.eventSubject.onNext((type, message))
      default:
        break
      }
    }
  }
  
  fileprivate func onUpdate() {
    self.socket?.on(CHSocketResponse.update.value) { [weak self] (data, ack) in
      dlog("socket on update")
      guard let data = data.get(index: 0) else { return }
      guard let json = JSON(rawValue: data) else { return }
      guard var type = WsServiceType(string: json["type"].stringValue) else { return }
      type = WsServiceType.Update.union(type)
      
      switch type {
      case WsServiceType.UpdateChannel:
        guard let channel = Mapper<CHChannel>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(UpdateChannel(payload: channel))
        self?.eventSubject.onNext((type, channel))
      case WsServiceType.UpdateSession:
        guard let session = Mapper<CHSession>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(UpdateSession(payload: session))
        self?.eventSubject.onNext((type, session))
        break
      case WsServiceType.UpdateUserChat:
        guard let userChat = Mapper<CHUserChat>()
          .map(JSONObject: json["entity"].object) else { return }
        if let lastMessage = Mapper<CHMessage>()
          .map(JSONObject: json["refers"]["message"].object),
          !lastMessage.isWelcome {
          mainStore.dispatchOnMain(UpdateMessage(payload: lastMessage))
        }
        if let manager = Mapper<CHManager>()
          .map(JSONObject: json["refers"]["manager"].object) {
          mainStore.dispatchOnMain(UpdateManager(payload: manager))
        }
        
        mainStore.dispatchOnMain(UpdateUserChat(payload: userChat))
        self?.eventSubject.onNext((type, userChat))
      case WsServiceType.UpdateMessage:
        guard let message = Mapper<CHMessage>()
          .map(JSONObject: json["entity"].object) else { return }
        self?.messageOnCreateSubject.onNext(message)
        mainStore.dispatchOnMain(UpdateMessage(payload: message))
        self?.eventSubject.onNext((type, message))
      case WsServiceType.UpdateUser:
        let user = Mapper<CHUser>()
          .map(JSONObject: json["entity"].object)
        mainStore.dispatchOnMain(UpdateGuest(payload: user))
        self?.eventSubject.onNext((type, user))
      case WsServiceType.UpdateVeil:
        let veil = Mapper<CHVeil>()
          .map(JSONObject: json["entity"].object) 
        mainStore.dispatchOnMain(UpdateGuest(payload: veil))
        self?.eventSubject.onNext((type, veil))
      case WsServiceType.UpdateManager:
        guard let manager = Mapper<CHManager>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(UpdateManager(payload: manager))
        self?.eventSubject.onNext((type, manager))
      default:
        break
      }
    }
  }
  
  fileprivate func onDelete() {
    self.socket?.on(CHSocketResponse.delete.value) { [weak self] (data, ack) in
      dlog("socket on delete")
      guard let data = data.get(index: 0) else { return }
      guard let json = JSON(rawValue: data) else { return }
      guard var type = WsServiceType(string: json["type"].stringValue) else { return }
      type = WsServiceType.Delete.union(type)
      
      switch type {
      case WsServiceType.DeleteSession:
        guard let session = Mapper<CHSession>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(DeleteSession(payload: session))
        self?.eventSubject.onNext((type, session))
      case WsServiceType.DeleteUserChat:
        guard let userChat = Mapper<CHUserChat>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(DeleteUserChat(payload: userChat.id))
        self?.eventSubject.onNext((type, userChat))
      case WsServiceType.DeleteMessage:
        guard let message = Mapper<CHMessage>()
          .map(JSONObject: json["entity"].object) else { return }
        mainStore.dispatchOnMain(DeleteMessage(payload: message))
        self?.eventSubject.onNext((type, message))
      default:
        break
      }
    }
  }
  
  fileprivate func onJoined() {
    self.socket?.on(CHSocketResponse.joined.value) { [weak self] (data, ack) in
      dlog("socket joined: \(data)")
      
      guard let userChatId = data.get(index: 0) as? String else { return }
      self?.joinSubject.onNext(userChatId)
      mainStore.dispatchOnMain(JoinedUserChat(payload: userChatId))
    }
  }
  
  fileprivate func onLeaved() {
    self.socket?.on(CHSocketResponse.leaved.value) { (data, ack) in
      dlog("socket leaved: \(data)")
      
      guard let userChatId = data.get(index: 0) as? String else { return }
      mainStore.dispatchOnMain(LeavedUserChat(payload: userChatId))
    }
  }
  
  fileprivate func onTyping() {
    self.socket?.on(CHSocketResponse.typing.value) {  [weak self] (data, ack) in
      guard let entity = data.get(index: 0) else { return }
      guard let json = JSON(rawValue: entity) else { return }
      guard let typing = Mapper<CHTypingEntity>().map(JSONObject: json.object) else { return }
      self?.typingSubject.onNext(typing)
    }
  }
  
  fileprivate func onPush() {
    self.socket?.on(CHSocketResponse.push.value) { (data, ack) in
      //dlog("socket pushed: \(data)")
      guard let entity = data.get(index: 0) else { return }
      guard let json = JSON(rawValue: entity) else { return }
      guard let push = Mapper<CHPush>().map(JSONObject: json.object) else { return }
      
      if mainStore.state.uiState.isChannelVisible {
        return
      }
      
      mainStore.dispatchOnMain(GetPush(payload: push))
    }
  }

  fileprivate func onAuthenticated() {
    self.socket?.on(CHSocketResponse.authenticated.value) { [weak self] (data, ack) in
      dlog("socket authenticated")
      
      if let s = self {
        dispatch {
          self?.heartbeatTimer = Foundation.Timer.scheduledTimer(
            timeInterval: 30,
            target: s,
            selector: #selector(WsService.heartbeat),
            userInfo: nil, repeats: true)
        }
      }
    }
  }
  
  fileprivate func onUnauthorized() {
    self.socket?.on(CHSocketResponse.unauthorized.value) { (data, ack) in
      dlog("unauthorized")
      self.errorSubject.onNext(nil)
    }
  }
  
  fileprivate func onReconnectAttempt() {
    self.socket?.on(CHSocketResponse.reconnect.value) { [weak self] (data, ack) in
      dlog("socket reconnect attempt")
      mainStore.dispatchOnMain(SocketReconnecting())
      self?.invalidateTimer()
    }
    
  }
  
  fileprivate func onDisconnect() {
    self.socket?.on(CHSocketResponse.disconnect.value) { (data, ack) in
      dlog("socket disconnected")
      self.errorSubject.onNext(nil)
      mainStore.dispatchOnMain(SocketDisconnected())
    }
  }
  
  fileprivate func onError() {
    self.socket?.on(CHSocketResponse.error.value) { (data, ack) in
      dlog("socket error with data: \(data)")
      self.errorSubject.onNext(nil)
      mainStore.dispatchOnMain(SocketDisconnected())
    }
  }
  
  fileprivate func emitAuth() {
    dlog("socket submitting auth")
    guard let jwt = PrefStore.getCurrentGuestKey() else { return }
    self.socket?.emit("authentication", ["jwt":jwt])
  }
}
