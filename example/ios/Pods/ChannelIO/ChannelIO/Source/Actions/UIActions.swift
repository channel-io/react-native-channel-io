//
//  UIActions.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 13..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

struct ShowProfile: Action {}

struct HideProfile: Action {}

struct ChatListIsVisible: Action {}

struct ChatListIsHidden: Action {}

//checkinState

struct UpdateCheckinState: Action {
  public let payload: ChannelPluginCompletionStatus
}
