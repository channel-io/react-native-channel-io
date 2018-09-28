//
//  UIState.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 13..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct UIState: StateType {
  var isChannelVisible: Bool = false
  var launcherIsHidden: Bool = true
  var profileIsHidden: Bool = true
}

/**
 *   Checkin result state
 *
 *    - success: Checkin success
 *    - notInitialized: pluginId is not initialized
 *    - networkTimeout: Network request timeout
 *    - duplicated: already checkin
 *    - notAvailableVersion: SDK version is not compatible
 *    - serviceUnderConstruction: server is out of service
 *    - checkinError: any other errors
 *    - requirePayment: your plan is not eligible to use SDK
 *    - accessDeined: accces to ChannelPlugin server denied
 */
@objc
public enum ChannelPluginCompletionStatus : Int {
  case success
  case notInitialized
  case networkTimeout
  case notAvailableVersion
  case serviceUnderConstruction
  case requirePayment
  case accessDenied
  case unknown
}

struct CheckinState: StateType {
  var status: ChannelPluginCompletionStatus = .notInitialized
}
