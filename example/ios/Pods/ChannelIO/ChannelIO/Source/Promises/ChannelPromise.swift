//
//  ChannelPromise.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import ObjectMapper
import SwiftyJSON

struct ChannelPromise {
  static func getManager(channelId: String) -> Observable<Any?> {
    return Observable.create { observer in
      return Disposables.create()
    }
  }
}
