//
//  PushReducer.swift
//  CHPlugin
//
//  Created by Haeun Chung on 13/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

func pushReducer(action:Action, push: CHPush?) -> CHPush? {
  switch action {
  case let action as GetPush:
    //return push only if messenger is not visible
    return action.payload
  case _ as RemovePush:
    return nil
  case _ as CheckOutSuccess:
    return nil
  default:
    return push ?? nil
  }
}
