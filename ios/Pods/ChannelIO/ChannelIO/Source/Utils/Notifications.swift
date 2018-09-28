//
//  Notifications.swift
//  ChannelIO
//
//  Created by R3alFr3e on 4/18/18.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import Foundation
import UIKit

extension Notification.Name {
  public struct Channel {
    public static let dismissKeyboard = Notification.Name(rawValue: "com.zoyi.channel.userchat.keyboard.dismiss")
    public static let presentKeyboard = Notification.Name(rawValue: "com.zoyi.channel.userchat.keyboard.present")
    public static let updateBadge = Notification.Name(rawValue: "com.zoyi.channel.plugin.update_badge")
    public static let dismissLaunchers = Notification.Name(rawValue: "com.zoyi.channel.plugin.dismiss_launchers")
  }
}
