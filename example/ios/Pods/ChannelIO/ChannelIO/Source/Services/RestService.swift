//
//  RestService.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import Alamofire

enum EPType: String {
  case PRODUCTION = "https://api.channel.io"
  case ALPHA = "http://api.exp.channel.io"
  case BETA = "http://api.staging.channel.io"
}

enum RestRouter: URLRequestConvertible {
  case Boot(String, ParametersType)
  case GetPlugin(String)
  
  case TouchGuest
  case GetUserChats(ParametersType)
  case GetUserChat(String)
  case CreateUserChat(String)
  case RemoveUserChat(String)
  case CloseUserChat(String, ParametersType)
  case ReviewUserChat(String, ParametersType)
  case GetMessages(String, ParametersType)
  case CreateMessage(String, ParametersType)
  case UploadFile(String, ParametersType)
  case SetMessagesRead(String, ParametersType)
  
  case RegisterToken(ParametersType)
  case UnregisterToken(String, ParametersType)
  case CheckVersion
  case GetGeoIP
  
  case SendEvent(ParametersType)
  case GetCountryCodes
  case GetFollowingManager
  
  case RequestProfileBot(String, String)
  case UpdateProfileItem(String, ParametersType)

  case Translate(String, ParametersType)
  
  var baseURL: String {
    get {
      var url = EPType.PRODUCTION.rawValue
      if let stage = CHUtils.getCurrentStage() {
        if stage == "PROD" {
          url = EPType.PRODUCTION.rawValue
        } else if stage == "ALPHA" {
          url = EPType.ALPHA.rawValue
        } else if stage == "BETA" {
          url = EPType.BETA.rawValue
        }
      }
      return url
    }
  }
  //#endif
  typealias ParametersType = Parameters
  static let queue = DispatchQueue(label: "com.zoyi.channel.restapi", qos: .background, attributes: .concurrent)
  
  var method: HTTPMethod {
    switch self {
    case .CreateMessage,
         .CreateUserChat, .UploadFile, .RegisterToken,
         .SendEvent, .Boot, .RequestProfileBot,
         .UpdateProfileItem, .TouchGuest:
      return .post
    case .GetMessages, .GetUserChat,
         .GetUserChats, .CheckVersion, .GetGeoIP,
         .GetCountryCodes,
         .GetFollowingManager,
         .GetPlugin, .Translate:
      return .get
    case .SetMessagesRead,
         .RemoveUserChat,
         .CloseUserChat,
         .ReviewUserChat:
      return .put
    case .UnregisterToken:
      return .delete
    }
  }
  
  // MARK: Paths
  var path: String {
    switch self {
    case .Boot(let pluginKey, _):
      return "/app/plugins/\(pluginKey)/boot/v2"
    case .TouchGuest:
      return "/app/guests/touch"
    case .GetPlugin(let pluginId):
      return "/app/plugins/\(pluginId)"
    case .GetUserChats:
      return "/app/user_chats"
    case .CreateUserChat(let pluginId):
      return "/app/plugins/\(pluginId)/user_chats"
    case .GetUserChat(let userChatId):
      return "/app/user_chats/\(userChatId)"
    case .RemoveUserChat(let userChatId):
      return "/app/user_chats/\(userChatId)/remove"
    case .CloseUserChat(let userChatId, _):
      return "/app/user_chats/\(userChatId)/close"
    case .ReviewUserChat(let userChatId, _):
      return "/app/user_chats/\(userChatId)/review"
    case .GetMessages(let userChatId, _):
      return "/app/user_chats/\(userChatId)/messages"
    case .CreateMessage(let userChatId, _):
      return "/app/user_chats/\(userChatId)/messages"
    case .UploadFile(let userChatId, _):
      return "/app/user_chats/\(userChatId)/messages/file"
    case .SetMessagesRead(let userChatId, _):
      return "/app/user_chats/\(userChatId)/messages/read"
    case .RegisterToken:
      return "/app/device_tokens"
    case .CheckVersion:
      return "/packages/com.zoyi.channel.plugin.ios/versions/latest"
    case .GetGeoIP:
      return "/geoip"
    case .UnregisterToken(let key, _):
      return "/app/device_tokens/ios/\(key)"
    case .SendEvent:
      return "/app/events"
    case .GetCountryCodes:
      return "/countries"
    case .GetFollowingManager:
      return "/app/channels/following_managers"
    case .RequestProfileBot(let pluginId, let chatId):
      return "/app/user_chats/\(chatId)/plugins/\(pluginId)/profile_bot"
    case .UpdateProfileItem(let messageId, _):
      return "/app/messages/\(messageId)/profile_bot"
    case .Translate(let messageId, _):
      return "/app/messages/\(messageId)/translate"
    }
  }
  
  func addAuthHeaders(request: URLRequest) -> URLRequest {
    var req = request
    var headers = req.allHTTPHeaderFields ?? [String: String]()
    
    if let key = PrefStore.getCurrentGuestKey() {
      headers["X-Guest-Jwt"] = key
    }
    
    if let locale = CHUtils.getLocale() {
      headers["X-Locale"] = locale.rawValue
    }
    
    let now = Date()
    let cookies = HTTPCookieStorage.shared.cookies?
      .filter({ (cookie) -> Bool in
        guard cookie.domain.hasSuffix("channel.io") else { return false }
        if let expDate = cookie.expiresDate, expDate > now {
          return true
        }  else {
          HTTPCookieStorage.shared.deleteCookie(cookie)
          return false
        }
    }) ?? []
    
    req.allHTTPHeaderFields = headers.merging(HTTPCookie.requestHeaderFields(with: cookies)) { $1 }
    return req
  }
  
  // MARK: Encoding
  func encode(_ urlRequest: URLRequestConvertible, with parameters: Parameters?) throws -> URLRequest {
    var request = urlRequest
    
    if let body = parameters?["body"] as? ParametersType {
      request = try JSONEncoding.default.encode(urlRequest, with: body)
    }
    
    if let url = parameters?["url"] as? ParametersType {
      request = try URLEncoding.default.encode(request, with: url)
    }
    
    if let query = parameters?["query"] as? ParametersType {
      request = try CustomQueryEncoding().encode(request, with: query)
    }
    
    if let paths = parameters?["paths"] as? [String] {
      for path in paths {
        request = request.urlRequest?.url?.absoluteString.appending(path) as! URLRequestConvertible
      }
    }
    
    if let headers = parameters?["headers"] as? ParametersType, var req = try? request.asURLRequest() {
      for (key, val) in headers {
        if let value = val as? String, value != "" {
          req.setValue(value, forHTTPHeaderField: key)
        }
      }
      request = req
    }
    
    return request as! URLRequest
  }
  
  // MARK: URLRequestConvertible
  func asURLRequest() throws -> URLRequest {
    let url = try self.baseURL.asURL()
    
    var urlRequest = URLRequest(url: url.appendingPathComponent(path))
    urlRequest.httpMethod = method.rawValue
    urlRequest.timeoutInterval = 5
    
    switch self {
    case .Boot(_, let params),
         .GetMessages(_, let params),
         .CreateMessage(_, let params), .UploadFile(_, let params),
         .GetUserChats(let params), .RegisterToken(let params),
         .SendEvent(let params),
         .UpdateProfileItem(_, let params),
         .Translate(_, let params),
         .CloseUserChat(_, let params),
         .ReviewUserChat(_, let params),
         .SetMessagesRead(_, let params),
         .UnregisterToken(_, let params):
      urlRequest = try encode(addAuthHeaders(request: urlRequest), with: params)
    case .GetUserChat, .GetPlugin,
         .GetCountryCodes,
         .GetFollowingManager,
         .RequestProfileBot,
         .CreateUserChat:
      urlRequest = try encode(addAuthHeaders(request: urlRequest), with: nil)
    default:
      urlRequest = try encode(addAuthHeaders(request: urlRequest), with: nil)
    }
    
    return urlRequest
  }
}
