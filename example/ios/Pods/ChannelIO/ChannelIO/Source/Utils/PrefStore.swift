//
//  PrefStore.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation

class PrefStore {
  static let CHANNEL_ID_KEY = "CHPlugin_ChannelId"
  static let VEIL_ID_KEY = "CHPlugin_VeilId"
  static let USER_ID_KEY = "CHPlugin_UserId"
  static let PUSH_OPTION_KEY = "CHPlugin_PushOption"
  static let VISIBLE_CLOSED_USERCHAT_KEY = "CHPlugin_visibility_of_userchat"
  static let CHANNEL_PLUGIN_SETTINGS_KEY = "CHPlugin_settings"
  static let VISIBLE_TRANSLATION = "CHPlugin_visible_translation"
  static let GUEST_KEY = "CHPlugin_x_guest_key"
  
  static func getCurrentChannelId() -> String? {
    return UserDefaults.standard.string(forKey: CHANNEL_ID_KEY)
  }
  
  static func getCurrentVeilId() -> String? {
    return UserDefaults.standard.string(forKey: VEIL_ID_KEY)
  }
  
  static func getCurrentUserId() -> String? {
    return UserDefaults.standard.string(forKey: USER_ID_KEY)
  }
  
  static func setCurrentChannelId(channelId: String) {
    UserDefaults.standard.set(channelId, forKey: CHANNEL_ID_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func setCurrentVeilId(veilId: String?) {
    if let veilId = veilId {
      UserDefaults.standard.set(veilId, forKey: VEIL_ID_KEY)
      UserDefaults.standard.synchronize()
    }
  }
  
  static func setCurrentUserId(userId: String?) {
    if let userId = userId {
      UserDefaults.standard.set(userId, forKey: USER_ID_KEY)
      UserDefaults.standard.synchronize()
    }
  }
  
  static func clearCurrentChannelId() {
    UserDefaults.standard.removeObject(forKey: CHANNEL_ID_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func clearCurrentVeilId() {
    UserDefaults.standard.removeObject(forKey: VEIL_ID_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func clearCurrentUserId() {
    UserDefaults.standard.removeObject(forKey: USER_ID_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func setVisibilityOfClosedUserChat(on: Bool) {
    UserDefaults.standard.set(on, forKey: VISIBLE_CLOSED_USERCHAT_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func getVisibilityOfClosedUserChat() -> Bool {
    if let closed = UserDefaults.standard.object(forKey: VISIBLE_CLOSED_USERCHAT_KEY) as? Bool {
      return closed
    }
    return false
  }
  
  static func setVisibilityOfTranslation(on: Bool) {
    UserDefaults.standard.set(on, forKey: VISIBLE_TRANSLATION)
    UserDefaults.standard.synchronize()
  }
  
  static func getVisibilityOfTranslation() -> Bool {
    if let visible = UserDefaults.standard.object(forKey: VISIBLE_TRANSLATION) as? Bool {
      return visible
    }
    return true
  }
  
  static func setChannelPluginSettings(pluginSetting: ChannelPluginSettings) {
    let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: pluginSetting)
    UserDefaults.standard.set(encodedData, forKey: CHANNEL_PLUGIN_SETTINGS_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func getChannelPluginSettings() -> ChannelPluginSettings? {
    if let data = UserDefaults.standard.object(forKey: CHANNEL_PLUGIN_SETTINGS_KEY) as? Data {
      return NSKeyedUnarchiver.unarchiveObject(with: data) as? ChannelPluginSettings
    }
    return nil
  }
  
  static func clearCurrentChannelPluginSettings() {
    UserDefaults.standard.removeObject(forKey: CHANNEL_PLUGIN_SETTINGS_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func setCurrentGuestKey(_ key: String?) {
    if let key = key {
      UserDefaults.standard.set(key, forKey: GUEST_KEY)
      UserDefaults.standard.synchronize()
    }
  }
  
  static func getCurrentGuestKey() -> String? {
    return UserDefaults.standard.string(forKey: GUEST_KEY)
  }
  
  static func clearCurrentGuestKey() {
    UserDefaults.standard.removeObject(forKey: GUEST_KEY)
    UserDefaults.standard.synchronize()
  }
  
  static func clearAllLocalData() {
    PrefStore.clearCurrentUserId()
    PrefStore.clearCurrentVeilId()
    PrefStore.clearCurrentChannelId()
    PrefStore.clearCurrentChannelPluginSettings()
    PrefStore.clearCurrentGuestKey()
  }
}
