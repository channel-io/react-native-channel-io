//
//  UtilityPromise.swift
//  CHPlugin
//
//  Created by Haeun Chung on 24/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RxSwift
import ObjectMapper

struct UtilityPromise {
  static func getGeoIP() -> Observable<GeoIPInfo> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.GetGeoIP)
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { (response) in
          switch response.result {
          case .success(let data):
            let json = SwiftyJSON.JSON(data)
            guard let geoData: GeoIPInfo = Mapper<GeoIPInfo>()
              .map(JSONObject: json["geoIP"].object) else {
                subscriber.onError(CHErrorPool.geoParseError)
                break
            }
            
            subscriber.onNext(geoData)
            subscriber.onCompleted()
            break
          case .failure(let error):
            subscriber.onError(error)
            break
          }
          
        })
      return Disposables.create()
    }
  }
  
  static func getCountryCodes() -> Observable<[CHCountry]> {
    return Observable.create { subscriber in
      if mainStore.state.countryCodeState.codes.count != 0 {
        let countries = mainStore.state.countryCodeState.codes
        subscriber.onNext(countries)
        subscriber.onCompleted()
        return Disposables.create()
      }
      
      Alamofire
        .request(RestRouter.GetCountryCodes)
        .validate(statusCode: 200..<300)
        .responseData(completionHandler: { (response) in
          switch response.result {
          case .success(let data):
            let json:JSON = JSON(data)
            guard let countries =  Mapper<CHCountry>()
              .mapArray(JSONObject: json["countries"].object) else {
                subscriber.onNext([])
                subscriber.onCompleted()
                return
            }
            
            subscriber.onNext(countries)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
          
        })
      return Disposables.create()
    }
  }
}
