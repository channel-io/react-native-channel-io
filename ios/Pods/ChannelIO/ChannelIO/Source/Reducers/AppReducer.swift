//
//  AppReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
  return AppState(
    checkinState: checkinReducer(action: action, state: state?.checkinState),
    plugin: pluginReducer(action: action, plugin: state?.plugin),
    channel: channelReducer(action: action, channel: state?.channel),
    guest: guestReducer(action: action, guest: state?.guest),
    userChatsState: userChatsReducer(action: action, state: state?.userChatsState),
    push: pushReducer(action: action, push: state?.push),
    managersState: managersReducer(action: action, state: state?.managersState),
    botsState: botsReducer(action: action, state: state?.botsState),
    sessionsState: sessionsReducer(action: action, state: state?.sessionsState),
    messagesState: messagesReducer(action: action, state: state?.messagesState),
    uiState: uiReducer(action: action, state: state?.uiState),
    socketState: socketReducer(action: action, state: state?.socketState),
    countryCodeState: countryCodeReducer(action: action, state: state?.countryCodeState),
    settings: settingReducer(action:action, state: state?.settings)
  )
}
