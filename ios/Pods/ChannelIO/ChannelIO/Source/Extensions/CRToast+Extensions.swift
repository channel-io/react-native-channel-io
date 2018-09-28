//
//  CRToast+Extensions.swift
//  CHPlugin
//
//  Created by R3alFr3e on 5/22/17.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import CRToast
import ObjectMapper
import SwiftyJSON

extension CRToastManager {
  static func showErrorFromData(_ data: Data?) {
    guard data != nil else { return }
    do {
      let json = try JSON(data: data!)
      guard let errors: [CHErrorResponse] = Mapper<CHErrorResponse>()
        .mapArray(JSONObject: json["errors"].object) else { return }
      errors.forEach { (error) -> () in
        CRToastManager.showErrorMessage(error.message)
      }
    } catch {
      return
    }
  }
  
  static func showErrorMessage(_ message: String) {
    CRToastManager.showNotification(withMessage: message, completionBlock: nil)
  }
}
