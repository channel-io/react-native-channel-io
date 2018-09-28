//
//  CHChannel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 1. 18..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct TimeRange {
  var from = 0
  var to = 0
}

extension TimeRange : Mappable {
  init?(map: Map) {
    
  }
  
  mutating func mapping(map: Map) {
    from <- map["from"]
    to <- map["to"]
  }
}

struct SortableWorkingTime {
  let value: String
  let order: Int
}

enum ServicePlanType: String {
  case free = "free"
  case startup = "startup"
  case pro = "pro"
}

struct CHChannel: CHEntity {
  // ModelType
  var id = ""
  // Avatar
  var avatarUrl: String?
  var initial = ""
  var color = ""
  // Channel
  var name = ""
  var country = ""
  var textColor = "white"
  var working = true
  var workingTime: [String:TimeRange]?
  var lunchTime: TimeRange?
  var phoneNumber: String = ""
  var requestGuestInfo = true
  var servicePlan: ServicePlanType = .startup
  var serviceBlocked = false
  var homepageUrl = ""
  var expectedResponseDelay = ""
  var timeZone = ""
  var awayOption = ""
  var workingType = ""
  var trial = true
  var trialExpiryDate: Date? = nil
  
  var workingTimeString: String {
    var workingTimeDictionary = self.workingTime
    if let launchTime = self.lunchTime {
      workingTimeDictionary?["lunch_time"] = launchTime
    }
    
    let workingTime = workingTimeDictionary?.map({ (key, value) -> SortableWorkingTime in
      let fromValue = value.from
      let toValue = value.to
      
      if fromValue == 0 && toValue == 0 {
        return SortableWorkingTime(value: "", order: 0)
      }
      
      let from = min(1439, fromValue)
      let to = min(1439, toValue)
      let fromTxt = from >= 720 ? "PM" : "AM"
      let toTxt = to >= 720 ? "PM" : "AM"
      let fromMin = from % 60
      let fromHour = from / 60 > 12 ? from / 60 - 12 : from / 60
      let toMin = to % 60
      let toHour = to / 60 > 12 ? to / 60 - 12 : to / 60
      
      let timeStr = String(format: "%@ - %d:%02d%@ ~ %d:%02d%@",
                      CHAssets.localized("ch.out_of_work.\(key)"),
                      fromHour, fromMin, fromTxt, toHour, toMin, toTxt)
      var order = 0
      switch key.lowercased() {
      case "mon": order = 1
      case "tue": order = 2
      case "wed": order = 3
      case "thu": order = 4
      case "fri": order = 5
      case "sat": order = 6
      case "sun": order = 7
      default: order = 8
      }
      
      return SortableWorkingTime(value: timeStr, order: order)
    }).sorted(by: { (wt, otherWt) -> Bool in
      return wt.order < otherWt.order
    }).filter({ $0.value != "" }).compactMap({ (wt) -> String? in
      return wt.value
    }).joined(separator: "\n")
    
    return  workingTime ?? "unknown"
  }
  
  var locked: Bool {
    return self.serviceBlocked || self.servicePlan == .free
  }
  
  var showWatermark: Bool {
    return self.serviceBlocked || self.servicePlan != .pro
  }
  
  var shouldHideDefaultButton: Bool {
    return self.awayOption == "hidden" && !self.working
  }

  var allowNewChat: Bool {
    return self.workingType == "always" ||
      self.awayOption == "active" ||
      (self.workingType == "custom" && self.working)
  }
  
  var shouldShowWorkingTimes: Bool {
    if let workingTime = self.workingTime, workingTime.count != 0 {
      return self.workingType == "custom" && !self.working
    }
    return false
  }
  
  var shouldShowSingleManager: Bool {
    return self.expectedResponseDelay == "delayed" || !self.working
  }
  
  func isDiff(from channel: CHChannel) -> Bool {
    return self.working != channel.working || self.workingType != channel.workingType ||
      self.expectedResponseDelay != channel.expectedResponseDelay
  }
}

extension CHChannel: Mappable {
  init?(map: Map) {}
  
  mutating func mapping(map: Map) {
    id                      <- map["id"]
    avatarUrl               <- map["avatarUrl"]
    initial                 <- map["initial"]
    color                   <- map["color"]
    name                    <- map["name"]
    country                 <- map["country"]
    textColor               <- map["textColor"]
    phoneNumber             <- map["phoneNumber"]
    working                 <- map["working"]
    workingTime             <- map["workingTime"]
    lunchTime               <- map["lunchTime"]
    requestGuestInfo        <- map["requestGuestInfo"]
    homepageUrl             <- map["homepageUrl"]
    expectedResponseDelay   <- map["expectedResponseDelay"]
    timeZone                <- map["timeZone"]
    servicePlan             <- map["servicePlan"]
    serviceBlocked          <- map["serviceBlocked"]
    workingType             <- map["workingType"] //always, never, custom
    awayOption              <- map["awayOption"] //active, disabled, hidden
    trial                   <- map["trial"]
    trialExpiryDate         <- (map["trialExpiryDate"], CustomDateTransform())
  }
}
