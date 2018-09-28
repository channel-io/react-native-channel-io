//
//  CountryCodeState.swift
//  CHPlugin
//
//  Created by R3alFr3e on 11/17/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import ReSwift

struct CountryCodeState: StateType {
  var codes: [CHCountry] = []
  
  mutating func insert(codes: [CHCountry]) -> CountryCodeState {
    self.codes = codes
    return self
  }
  
  mutating func clear() -> CountryCodeState {
    self.codes.removeAll()
    return self
  }
}
