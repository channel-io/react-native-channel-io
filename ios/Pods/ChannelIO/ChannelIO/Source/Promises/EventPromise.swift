//
//  EventPromise.swift
//  CHPlugin
//
//  Created by Haeun Chung on 28/08/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import ObjectMapper

struct EventPromise {
  static func sendEvent(
    name: String,
    properties: [String: Any?]? = nil,
    sysProperties: [String: Any?]? = nil) -> Observable<CHEvent> {
    return Observable.create { subscriber in
      var params = [
        "body": [String:AnyObject]()
      ]
      
      params["body"]?["name"] = name as AnyObject?
      
      if let properties = properties, properties.count != 0 {
        params["body"]?["property"] = properties as AnyObject?
      }
      
      if let sysProperties = sysProperties, sysProperties.count != 0 {
        params["body"]?["sysProperty"] = sysProperties as AnyObject?
      }
      
      Alamofire.request(RestRouter.SendEvent(params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { (response) in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let event = Mapper<CHEvent>()
              .map(JSONObject: json["event"].object) else {
              subscriber.onError(CHErrorPool.eventParseError)
              return
            }
            subscriber.onNext(event)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      
      return Disposables.create()
    }
  }
}
