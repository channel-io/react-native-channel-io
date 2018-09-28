//
//  GuestReducer.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 8..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import ReSwift

func guestReducer(action: Action, guest: CHGuest?) -> CHGuest {
  var guest = guest
  switch action {
  case let action as CheckInSuccess:
    if let key = action.payload["guestKey"] as? String {
      PrefStore.setCurrentGuestKey(key)
    }
    if let user = action.payload["user"] as? CHUser {
      PrefStore.setCurrentUserId(userId: user.id)
      return user
    } else if let veil = action.payload["veil"] as? CHVeil {
      PrefStore.setCurrentVeilId(veilId: veil.id)
      return veil
    }
    return guest ?? CHVeil()
  case let action as UpdateGuest:
    guest = action.payload
    return guest ?? CHVeil()
  case _ as CheckOutSuccess:
    return CHVeil()
  default:
    return guest ?? CHVeil()
  }
}

