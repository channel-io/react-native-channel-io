//
//  ChannelPluginSettings.swift
//  CHPlugin
//
//  Created by Haeun Chung on 29/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation

struct ChannelPluginSettingKey {
  static let pluginKey = "ch_pluginKey"
  static let userId = "ch_userId"
  static let debugMode = "ch_debugMode"
  static let launcherConfig = "ch_launcherConfig"
  static let hideDefaultLauncher = "ch_hideDefaultLauncher"
  static let hideDefaultInAppPush = "ch_hideDefaultInAppPush"
  static let enabledTrackDefaultEvent = "ch_enabledTrackDefaultEvent"
  static let locale = "ch_locale"
}

@objc
public class ChannelPluginSettings: NSObject, NSCoding {
  /* pluinkey that you can obtain from channel desk */
  @objc public var pluginKey: String = ""
  
  /* user id to distinguish normal user and anonymous user */
  @objc public var userId: String? = nil
  
  /* true if debug information to be printed in console. Default is false */
  @objc public var debugMode: Bool = false
  
  /* launcher specific configuration object */
  @objc public var launcherConfig: LauncherConfig?
  
  /* true if default launcher button not to be displayed. Default is false */
  @available(*, deprecated)
  @objc public var hideDefaultLauncher: Bool = false
  
  /* true if default in-app push notification not to be displayed. Default is false */
  @objc public var hideDefaultInAppPush: Bool = false
  
  /* true if tracking default event. Default is true **/
  @objc public var enabledTrackDefaultEvent: Bool = true
  
  /* force to use a specific langauge. Currently supports en, ko, ja*/
  @objc public var locale: CHLocale {
    get {
      if self.appLocale == .japanese {
        return .japanese
      } else if self.appLocale == .korean {
        return .korean
      } else {
        return .english
      }
    }
    set {
      if newValue == .korean {
        self.appLocale = .korean
      } else if newValue == .japanese {
        self.appLocale = .japanese
      } else {
        self.appLocale = .english
      }
    }
  }
  
  var appLocale: CHLocaleString? = nil
  
  @objc override public init() {
    super.init()
  }
  
  @objc public init(
    pluginKey: String,
    userId: String? = nil,
    debugMode: Bool = false,
    launcherConfig: LauncherConfig? = nil,
    hideDefaultLauncher: Bool = false,
    hideDefaultInAppPush: Bool = false,
    enabledTrackDefaultEvent: Bool = true,
    locale: CHLocale = .device) {
    super.init()
    
    self.pluginKey = pluginKey
    self.userId = userId
    self.debugMode = debugMode
    self.launcherConfig = launcherConfig
    self.hideDefaultLauncher = hideDefaultLauncher
    self.hideDefaultInAppPush = hideDefaultInAppPush
    self.enabledTrackDefaultEvent = enabledTrackDefaultEvent

    if locale == .device {
      let deviceLocale = CHUtils.getLocale()
      if deviceLocale == .japanese {
        self.locale = .japanese
      } else if deviceLocale == .korean {
        self.locale = .korean
      } else {
        self.locale = .english
      }
    } else {
      self.locale = locale
    }
  }
  
  required convenience public init(coder aDecoder: NSCoder) {
    //remove legacy key later
    let pluginKey = aDecoder.decodeObject(forKey: ChannelPluginSettingKey.pluginKey) as? String ??
      aDecoder.decodeObject(forKey: "pluginKey") as? String ?? ""
    let userId = aDecoder.decodeObject(forKey: ChannelPluginSettingKey.userId) as? String ??
      aDecoder.decodeObject(forKey: "userId") as? String
    let debugMode = aDecoder.decodeBool(forKey: ChannelPluginSettingKey.debugMode) || aDecoder.decodeBool(forKey: "debugMode")
    let launcherConfig = aDecoder.decodeObject(forKey: ChannelPluginSettingKey.launcherConfig) as? LauncherConfig ??
      aDecoder.decodeObject(forKey: "launcherConfig") as? LauncherConfig
    let hideDefaultLauncher = aDecoder.decodeBool(forKey: ChannelPluginSettingKey.hideDefaultLauncher) ||
      aDecoder.decodeBool(forKey: "hideDefaultLauncher")
    let hideDefaultInAppPush = aDecoder.decodeBool(forKey: ChannelPluginSettingKey.hideDefaultInAppPush) ||
      aDecoder.decodeBool(forKey: "hideDefaultInAppPush")
    let enabledTrackDefaultEvent = aDecoder.decodeBool(forKey: ChannelPluginSettingKey.enabledTrackDefaultEvent) ||
      aDecoder.decodeBool(forKey: "enabledTrackDefaultEvent")
    let locale = CHLocale(rawValue: aDecoder.decodeInteger(forKey: ChannelPluginSettingKey.locale)) ?? .device
    
    self.init(pluginKey: pluginKey,
      userId: userId,
      debugMode: debugMode,
      launcherConfig: launcherConfig,
      hideDefaultLauncher: hideDefaultLauncher,
      hideDefaultInAppPush: hideDefaultInAppPush,
      enabledTrackDefaultEvent: enabledTrackDefaultEvent,
      locale: locale)
  }
  
  public func encode(with aCoder: NSCoder) {
    aCoder.encode(self.pluginKey, forKey: ChannelPluginSettingKey.pluginKey)
    aCoder.encode(self.userId, forKey: ChannelPluginSettingKey.userId)
    aCoder.encode(self.debugMode, forKey: ChannelPluginSettingKey.debugMode)
    aCoder.encode(self.launcherConfig, forKey: ChannelPluginSettingKey.launcherConfig)
    aCoder.encode(self.hideDefaultLauncher, forKey: ChannelPluginSettingKey.hideDefaultLauncher)
    aCoder.encode(self.hideDefaultInAppPush, forKey: ChannelPluginSettingKey.hideDefaultInAppPush)
    aCoder.encode(self.enabledTrackDefaultEvent, forKey: ChannelPluginSettingKey.enabledTrackDefaultEvent)
    aCoder.encode(self.locale.rawValue, forKey: ChannelPluginSettingKey.locale)
  }
  
  @discardableResult
  @objc public func set(userId: String?) -> ChannelPluginSettings {
    self.userId = userId
    return self
  }
  
  @discardableResult
  @objc public func set(pluginKey: String) -> ChannelPluginSettings {
    self.pluginKey = pluginKey
    return self
  }
  
  @discardableResult
  @objc public func set(debugMode: Bool) -> ChannelPluginSettings {
    self.debugMode = debugMode
    return self
  }
  
  @discardableResult
  @objc public func set(launcherConfig: LauncherConfig?) -> ChannelPluginSettings {
    self.launcherConfig = launcherConfig
    return self
  }
  
  @discardableResult
  @available(*, deprecated)
  @objc public func set(hideDefaultLauncher: Bool) -> ChannelPluginSettings {
    self.hideDefaultLauncher = hideDefaultLauncher
    return self
  }
  
  @discardableResult
  @objc public func set(hideDefaultInAppPush: Bool) -> ChannelPluginSettings {
    self.hideDefaultInAppPush = hideDefaultInAppPush
    return self
  }
  
  @discardableResult
  @objc public func set(enabledTrackDefaultEvent: Bool) -> ChannelPluginSettings {
    self.enabledTrackDefaultEvent = enabledTrackDefaultEvent
    return self
  }
  
  @discardableResult
  @objc public func set(locale: CHLocale) -> ChannelPluginSettings {
    self.locale = locale
    return self
  }
}
