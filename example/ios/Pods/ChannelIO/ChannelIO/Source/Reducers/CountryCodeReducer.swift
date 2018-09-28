//
//  CountryCodeReducer.swift
//  CHPlugin
//
//  Created by R3alFr3e on 11/17/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

func countryCodeReducer(action: Action, state: CountryCodeState?) -> CountryCodeState {
  var state = state
  switch action {
  case let action as GetCountryCodes:
    return state?.insert(codes: action.payload) ?? CountryCodeState()
  case _  as CheckOutSuccess:
    return state?.clear() ?? CountryCodeState()
  default:
    return state ?? CountryCodeState()
  }
}

