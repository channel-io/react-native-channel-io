//
//  Date+Extensions.swift
//  CHPlugin
//
//  Created by Haeun Chung on 08/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation

extension Date {
  func readableShortString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateStyle = .none
    formatter.timeStyle = .short
    return formatter.string(from: self)
  }
  
  func readableDateString() -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateStyle = .long
    formatter.timeStyle = .none
    return formatter.string(from: self)
  }
  
  func fullDateString() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return formatter.string(from: self)
  }
  
  func readableTimeStamp() -> String {
    let cal = NSCalendar.current
    let now = Date()
    
    let end = now
    let start = self
    
    //let flags = NSCalendarUnit.Day
    let startComponents = cal.dateComponents([.year, .day, .month,.minute, .hour], from: start)
    let endComponents = cal.dateComponents([.year], from: end)
    
    if cal.isDate(start, inSameDayAs: end), var hours = startComponents.hour, let minute = startComponents.minute {
      let suffix = hours >= 12 ? "PM" : "AM"
      hours = hours > 12 ? hours - 12 : hours
      return String(format:"%d:%02d %@", hours, minute, suffix)
    } else if let startYear = startComponents.year, let endYear = endComponents.year, startYear == endYear {
      return "\(startComponents.month ?? 0)/\(startComponents.day ?? 0)"
    }
    
    let year = startComponents.year ?? 0
    let month = startComponents.month ?? 0
    let day = startComponents.day ?? 0
    return "\(year)/\(month)/\(day)"
  }

  func printDate() -> String {
    let todaysDate:Date = Date()
    let cal = Calendar(identifier: Calendar.Identifier.gregorian)
    let comps = (cal as Calendar).dateComponents([.year,.month,.day], from: todaysDate)
    let comps2 = (cal as Calendar).dateComponents([.year,.month,.day], from: self)
    if comps.year == comps2.year && comps.month == comps2.month && comps.day == comps2.day {
      return self.readableShortString()
    } else {
      if comps.year == comps2.year {
        return String(describing: comps2.month!) + "/" + String(describing: comps2.day!)
      } else {
        return String(describing: comps2.year!) + "/" + String(describing: comps2.month!) + "/" + String(describing: comps2.day!)
      }
    }
  }
  
  func getMicroseconds() -> Int64 {
    return Int64(self.timeIntervalSince1970 * 1000.0 * 1000.0)
  }
  
  static func from(year: Int, month: Int, day: Int) -> Date {
    let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!
    
    var dateComponents = DateComponents()
    dateComponents.year = year
    dateComponents.month = month
    dateComponents.day = day
    
    let date = gregorianCalendar.date(from: dateComponents)!
    return date
  }
}

