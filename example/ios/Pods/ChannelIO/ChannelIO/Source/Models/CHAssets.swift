 //
//  Assets.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import AVFoundation

class CHAssets {
  class func mainBundle() -> Bundle {
    return Bundle(for: self)
  }
  
  class func getImage(named: String) -> UIImage? {
    let bundle = Bundle(for: self)
    return UIImage(named: named, in: bundle, compatibleWith: nil)
  }

  class func getPath(name: String, type: String) -> String? {
    return Bundle(for: self).path(forResource: name, ofType: type)
  }
  
  class func getData(named: String, type: String) -> Data? {
    let bundle = Bundle(for: self)
    if #available(iOS 9.0, *) {
      return NSDataAsset(name: named, bundle: bundle)?.data
    } else {
      do {
        guard let url = try bundle.path(forResource: named, ofType: type)?.asURL() else {
          return nil
        }
        return try Data(contentsOf: url)
      } catch {
        return nil
      }
    }
  }
  
  class func localized(_ key: String) -> String {
    if let settings = mainStore.state.settings, let locale = settings.appLocale?.rawValue {
      guard let path = Bundle(for: self).path(forResource: locale, ofType: "lproj") else { return "" }
      guard let bundle = Bundle.init(path: path) else { return "" }
      return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    } else {
      let bundle = Bundle(for: self)
      return NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    }
  }
  
  class func attributedLocalized(_ key: String) -> NSMutableAttributedString {
    let bundle = Bundle(for: self)
    let localizedString = NSLocalizedString(key, tableName: nil, bundle: bundle, value: "", comment: "")
    let data = localizedString.data(using: .utf16)
    do {
      let result = try NSMutableAttributedString(
        data: data!,
        options: [.documentType: NSAttributedString.DocumentType.html],
        documentAttributes: nil)
      return result
    } catch _ {
      return NSMutableAttributedString(string: localizedString)
    }
  }
  
  class func playPushSound() {
    let pushSound = NSURL(fileURLWithPath: Bundle(for:self).path(forResource: "ringtone", ofType: "mp3")!)
    var soundId: SystemSoundID = 0
    AudioServicesCreateSystemSoundID(pushSound, &soundId)
    
    Mute.shared.checkInterval = 0.5
    Mute.shared.alwaysNotify = true
    Mute.shared.isPaused = false
    Mute.shared.schedulePlaySound()
    Mute.shared.notify = { m in
      if !m {
        AudioServicesPlaySystemSound(soundId)
      } else {
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
      }
      Mute.shared.isPaused = true
      Mute.shared.alwaysNotify = false
    }
  }
}
