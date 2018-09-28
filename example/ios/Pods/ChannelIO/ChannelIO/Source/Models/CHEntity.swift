//
//  Entity.swift
//  CHPlugin
//
//  Created by Haeun Chung on 16/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation

protocol CHEntity : ModelType {
  var name: String { get set }
  var avatarUrl: String? { get set }
}

extension CHEntity {
  var kind: String! {
    get {
      let str = String(describing: type(of: self))
      let startIndex = str.index(str.startIndex, offsetBy: 2)
      return String(str[startIndex..<str.endIndex])
    }
  }
  
  var key: String {
    get {
      return "\(self.name):\(self.id)"
    }
  }
}
