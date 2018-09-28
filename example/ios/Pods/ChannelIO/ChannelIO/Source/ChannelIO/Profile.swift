//
//  Checkin.swift
//  CHPlugin
//
//  Created by Haeun Chung on 17/03/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//
import Foundation

@objc
public class Profile : NSObject {
  @objc public var name: String = ""
  @objc public var avatarUrl: String = ""
  @objc public var mobileNumber: String = ""
  @objc public var email: String = ""
  @objc public var property:[String:Any] = [:]
  
  @discardableResult
  @objc public func set(name: String) -> Profile {
    self.name = name
    return self
  }
  
  @discardableResult
  @objc public func set(avatarUrl: String) -> Profile {
    self.avatarUrl = avatarUrl
    return self
  }
  
  @discardableResult
  @objc public func set(mobileNumber: String) -> Profile {
    self.mobileNumber = mobileNumber
    return self
  }
  
  @discardableResult
  @objc public func set(email: String) -> Profile {
    self.email = email
    return self
  }
  
  @discardableResult
  @objc public func set(propertyKey:String, value:Any) -> Profile {
    self.property[propertyKey] = value
    return self
  }
  
  internal func generateParams() -> [String: Any] {
    var params = [String: Any]()
    if self.name != "" {
      params["name"] = self.name
    }
    
    if self.email != "" {
      params["email"] = self.email
    }
    
    if self.mobileNumber != "" {
      params["mobileNumber"] = self.mobileNumber
    }
    
    if self.avatarUrl != "" {
      params["avatarUrl"] = self.avatarUrl
    }
    
    if self.property.count != 0 {
      params["property"] = self.property
    }
    
    return params
  }
}
