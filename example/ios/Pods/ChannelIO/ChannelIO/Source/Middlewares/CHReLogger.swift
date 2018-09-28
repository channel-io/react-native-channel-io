//
//  CHReLogger.swift
//  CHPlugin
//
//  Created by Haeun Chung on 11/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

let loggingMiddleware: Middleware<Any> = { dispatch, getState in
  return { next in
    return { action in
      let actionName = type(of: action)
      dlog("[REDUX]: \(actionName)")
      return next(action)
    }
  }
}


