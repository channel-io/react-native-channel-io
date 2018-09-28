//
//  LauncherViewModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 2..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import UIKit

protocol LauncherViewModelType {
  var bgColor: String { get }
  var borderColor: String { get }
  var badge: Int { get }
  var iconColor: UIColor { get }
}

struct LauncherViewModel: LauncherViewModelType {
  var bgColor = "#00A6FF"
  var borderColor = ""
  var badge = 0
  var iconColor = UIColor.white
  var position = LauncherPosition.right
  
  init(plugin: CHPlugin, guest: CHGuest? = nil) {
    self.bgColor = plugin.color
    self.borderColor = plugin.borderColor
    self.iconColor = (plugin.textColor == "white") ? UIColor.white : UIColor.black
    self.badge = guest?.alert ?? 0
  }
}
