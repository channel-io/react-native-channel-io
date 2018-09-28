//
//  NSError.swift
//  CHPlugin
//
//  Created by Haeun Chung on 31/10/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation

enum CHErrorCode: Int {
  case unknownError = 8000
  case pluginParseError = 8001
  case registerParseError = 8002
  case eventParseError = 8003
  case guestParseError = 8004
  case scriptParseError = 8005
  case userChatParseError = 8006
  case chatResponseParseError = 8007
  case messageParseError = 8008
  case geoParseError = 8009
  case unregisterError = 9000
  case versionError = 9001
  case userChatRemoveError = 9002
  case uploadError = 9003
  case readAllError = 9004
  case sendFileError = 9005
  case serviceBlockedError = 9006
  case pluginKeyError = 9007
}

enum CHErrorDomain: String {
  case pluginPromise = "PluginPromise"
  case eventPromise = "EventPromise"
  case guestPromise = "GuestPromise"
  case scriptPromise = "ScriptPromise"
  case userChatPromise = "UserChatPromise"
  case utilityPromise = "UtilityPromise"
  case message = "CHMessage"
  case channelPlugin = "ChannelPlugin"
}

class CHError: NSError {
  init(domain: CHErrorDomain, code: CHErrorCode) {
    super.init(domain: domain.rawValue, code: code.rawValue, userInfo: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

struct CHErrorPool {
  static let unknownError = CHError(domain: .channelPlugin, code: .unknownError)
  static let pluginKeyError = CHError(domain: .channelPlugin, code: .pluginKeyError)
  static let pluginParseError = CHError(domain: .pluginPromise, code: .pluginParseError)
  static let registerParseError = CHError(domain: .pluginPromise, code: .registerParseError)
  static let unregisterError = CHError(domain: .pluginPromise, code: .unregisterError)
  static let versionError = CHError(domain: .pluginPromise, code: .versionError)
  static let eventParseError = CHError(domain: .eventPromise, code: .eventParseError)
  static let guestParseError = CHError(domain: .guestPromise, code: .guestParseError)
  static let userChatParseError = CHError(domain: .userChatPromise, code: .userChatParseError)
  static let chatResponseParseError = CHError(domain: .userChatPromise, code: .chatResponseParseError)
  static let userChatRemoveError = CHError(domain: .userChatPromise, code: .userChatRemoveError)
  static let messageParseError = CHError(domain: .userChatPromise, code: .messageParseError)
  static let uploadError = CHError(domain: .userChatPromise, code: .uploadError)
  static let readAllError = CHError(domain: .userChatPromise, code: .readAllError)
  static let geoParseError = CHError(domain: .utilityPromise, code: .geoParseError)
  static let sendFileError = CHError(domain: .message, code: .sendFileError)
  static let serviceBlockedError = CHError(domain: .channelPlugin, code: .serviceBlockedError)
}

