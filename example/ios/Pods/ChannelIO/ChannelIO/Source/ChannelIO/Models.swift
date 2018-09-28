//
//  Models.swift
//  ChannelIO
//
//  Created by R3alFr3e on 5/23/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation

@objc
public class PushEvent: NSObject {
  @objc public let chatId: String
  @objc public let message: String
  @objc public let senderName: String
  @objc public let senderAvatarUrl: String
  
  init(with pushData: CHPush?) {
    self.chatId = pushData?.userChat?.id ?? ""
    self.message = pushData?.message?.message ?? ""
    self.senderName = pushData?.manager?.name ?? ""
    self.senderAvatarUrl = pushData?.manager?.avatarUrl ?? ""
  }
  
  func toJson() -> Dictionary<String, Any?> {
    return [
      "chatId": self.chatId,
      "message": self.message,
      "senderName": self.senderName,
      "senderAvatarUrl": self.senderAvatarUrl
    ]
  }
}

@objc
public class Guest: NSObject {
  @objc public let id: String
  @objc public let name: String
  @objc public let avatarUrl: String?
  @objc public let profile: [String : Any]?
  @objc public let alert: Int
  
  init(with guest: CHGuest) {
    self.id = guest.id
    self.name = guest.name
    self.avatarUrl = guest.avatarUrl
    self.profile = guest.profile
    self.alert = guest.alert
  }
  
  func toJson() -> Dictionary<String, Any?> {
    return [
      "id": self.id,
      "name": self.name,
      "avatarUrl": self.avatarUrl,
      "profile": self.profile,
      "alert": self.alert
    ]
  }
}

@objc
public enum LauncherPosition: Int {
  case right
  case left
}

@objc
public class LauncherConfig: NSObject, NSCoding {
  @objc public var position: LauncherPosition = .right
  @objc public var xMargin: Float = 20
  @objc public var yMargin: Float = 20
  
  override public init() { }
  
  public init(position: LauncherPosition, xMargin: Float, yMargin: Float) {
    self.position = position
    self.xMargin = xMargin
    self.yMargin = yMargin
  }
  
  required convenience public init(coder aDecoder: NSCoder) {
    let position = LauncherPosition(rawValue: aDecoder.decodeInteger(forKey: "position")) ?? .right
    let xMargin = aDecoder.decodeFloat(forKey: "xMargin")
    let yMargin = aDecoder.decodeFloat(forKey: "yMargin")
    
    self.init(position: position, xMargin: xMargin, yMargin: yMargin)
  }
 
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.position.rawValue, forKey: "position")
    aCoder.encode(self.xMargin, forKey: "xMargin")
    aCoder.encode(self.yMargin, forKey: "yMargin")
  }
}
