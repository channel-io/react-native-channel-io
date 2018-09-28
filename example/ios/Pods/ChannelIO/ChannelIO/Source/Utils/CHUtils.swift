//
//  Utils.swift
//  CHPlugin
//
//  Created by Haeun Chung on 13/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SwiftyJSON
import ObjectMapper

class CHUtils {
  class func getTopController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
    if let navigation = base as? UINavigationController {
      return getTopController(base: navigation.visibleViewController)
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return getTopController(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return getTopController(base: presented)
    }
    
    return base
  }
  
  class func getTopNavigation(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UINavigationController? {
    if let navigation = base as? UINavigationController {
      return navigation
    }
    if let tab = base as? UITabBarController {
      if let selected = tab.selectedViewController {
        return getTopNavigation(base: selected)
      }
    }
    if let presented = base?.presentedViewController {
      return getTopNavigation(base: presented)
    }
    
    return base?.navigationController
  }
  
  class func nameToExt(name: String) -> String {
    switch name {
      case "png", "image":
        return "image/png"
      case "gif":
        return "image/gif"
      case "json":
        return "application/json"
      default:
        return "text/plain"
    }
  }
  
  class func emojiMap() -> [String: String] {
    if let path = CHAssets.getPath(name: "emojis", type: "json") {
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
        let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
        if let jsonResult = jsonResult as? Dictionary<String, Array<Any?>> {
          return CHUtils.parseEmojiIntoMap(dict: jsonResult)
        }
      } catch {
        return [:]
      }
    }
    
    return [:]
  }
  
  class func parseEmojiIntoMap(dict: Dictionary<String, Array<Any?>>) -> [String: String] {
    var maps: [String: String] = [:]
    for emojis in dict.values {
      for each in emojis {
        if let each = each as? Dictionary<String, Any> {
          let key = each["n"] as? String ?? ""
          let value = each["c"] as? String ?? ""
          maps[key] = value
        }
      }
    }
    
    return maps
  }
  
  class func getUrlForUTM(source: String, content: String) -> String {
    return "https://channel.io/ko/?utm_campaign=iOS&utm_source=\(source)&utm_medium=plugin&utm_content=\(content)"
  }
  
  class func getCountryDialCode(countryCode: String) -> String? {
    for each in mainStore.state.countryCodeState.codes {
      if each.code == countryCode {
        return each.dial
      }
    }
    return nil
  }
  
  class func getLocale() -> CHLocaleString? {
    if let settings = mainStore.state.settings, let locale = settings.appLocale {
      return locale
    } else {
      guard let str = NSLocale.preferredLanguages.get(index: 0) else { return nil }
      let start = str.startIndex
      let end = str.index(str.startIndex, offsetBy: 2)
      let locale = String(str[start..<end])
      
      if locale == "en" {
        return .english
      } else if locale == "ko" {
        return .korean
      } else if locale == "ja" {
        return .japanese
      }
      return .english
    }
  }
  
  class func getCurrentStage() -> String? {
    return Bundle(for: self).object(forInfoDictionaryKey: "Stage") as? String
  }
  
  class func secondsToComponents(seconds: Int) -> (Int, Int, Int, Int) {
    return (seconds/86400,
            (seconds%86400)/3600,
            ((seconds%86400)%3600)/60,
            (((seconds%86400)%3600)%60))
  }
  
  class func secondsToRedableString(seconds: Int) -> String {
    let components = CHUtils.secondsToComponents(seconds: seconds)
    var durationText = ""
    if components.0 > 0 {
      durationText += String(format: CHAssets.localized("%d day"), components.0)
    }
    if components.1 > 0 {
      durationText += "\(components.1)" + CHAssets.localized("ch.review.complete.time.hour")
    }
    if components.2 > 0 {
      durationText += "\(components.2)" + CHAssets.localized("ch.review.complete.time.minute")
    }
    if components.2 == 0 && components.3 > 0 {
      durationText += "1" + CHAssets.localized("ch.review.complete.time.minute")
    }
    
    return durationText
  }

  @discardableResult
  class func saveToDisk<T: Encodable>(with name: String, object: T) -> Bool {
    var data:Data?
    do {
      data = try JSONEncoder().encode(object)
      guard let data = data else { return false }
      let fm = FileManager.default
      let url1 = try fm.url(
        for:.applicationSupportDirectory,
        in:[.userDomainMask],
        appropriateFor:nil, create:true)
      let url2 = url1.appendingPathComponent(name)
      try data.write(to:url2)
      return true
    } catch {
      return false
    }
  }
  
  class func readFromDisk<T: Decodable>(with name: String, type: T.Type) -> Any? {
    do {
      let fm = FileManager.default
      let decoder = JSONDecoder()
      let url1 = try fm.url(
        for:.applicationSupportDirectory,
        in:[.userDomainMask],
        appropriateFor:nil, create:true)
      let url2 = url1.appendingPathComponent(name)

      if let data = try? Data(contentsOf: url2),
        let object = try? decoder.decode(type, from: data) {
        return object
      }
      return nil
    } catch {
      return nil
    }
  }
  
  class func bootQueryParams() -> [String: Any] {
    var params = [String :Any]()
    params["sysProfile.platform"] = "iOS"
    params["sysProfile.version"] = Bundle(for: ChannelIO.self)
      .infoDictionary?["CFBundleShortVersionString"] as? String ?? "unknown"
    return params
  }
}

typealias dispatchClosure = () -> Void

func dispatch(delay: Double = 0.0, execute: @escaping dispatchClosure) {
  DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: {
    execute()
  })
}

extension TimeInterval {
  
  /**
   Checks if `since` has passed since `self`.
   
   - Parameter since: The duration of time that needs to have passed for this function to return `true`.
   - Returns: `true` if `since` has passed since now.
   */
  func hasPassed(since: TimeInterval) -> Bool {
    return Date().timeIntervalSinceReferenceDate - self > since
  }
  
}
/**
 Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
 
 - Parameter delay: A `TimeInterval` specifying the number of seconds that needst to pass between each execution of `action`.
 - Parameter queue: The queue to perform the action on. Defaults to the main queue.
 - Parameter action: A function to throttle.
 
 - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
 */
func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
  var currentWorkItem: DispatchWorkItem?
  var lastFire: TimeInterval = 0
  return {
    guard currentWorkItem == nil else { return }
    currentWorkItem = DispatchWorkItem {
      action()
      lastFire = Date().timeIntervalSinceReferenceDate
      currentWorkItem = nil
    }
    if delay.hasPassed(since: lastFire) {
      queue.async(execute: currentWorkItem!)
    } else {
      currentWorkItem = nil
    }
  }
}

func throttle<T>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
  var currentWorkItem: DispatchWorkItem?
  var lastFire: TimeInterval = 0
  return { (p1: T) in
    guard currentWorkItem == nil else { return }
    currentWorkItem = DispatchWorkItem {
      action(p1)
      lastFire = Date().timeIntervalSinceReferenceDate
      currentWorkItem = nil
    }
    //if time has passed, execute workitem. Otherwise, abandon work
    if delay.hasPassed(since: lastFire) {
      queue.async(execute: currentWorkItem!)
    } else {
      currentWorkItem = nil
    }
  }
}

