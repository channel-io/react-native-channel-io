//
//  PersonSelector.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ReSwift

func personSelector(state: AppState, personType: String?, personId: String?) -> CHEntity? {
  guard let personType = personType else { return nil }
  guard let personId = personId else { return nil }
  
  if personType == "Manager" {
    return state.managersState.findBy(id: personId)
  } else if personType == "User" || personType == "Veil" {
    return state.guest
  } else if personType == "Bot" {
    return state.botsState.findBy(id: personId)
  }
  return state.channel
}
