//
//  Avatar.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation

protocol CHAvatar: ModelType {
  var avatarUrl: URL? { get }
  var initial: String { get }
  var color: String { get }
}
