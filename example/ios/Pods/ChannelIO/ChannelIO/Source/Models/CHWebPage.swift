//
//  WebPage.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 6..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import Foundation
import ObjectMapper

struct CHWebPage {
  var url = ""
  var title: String?
  var description: String?
  var imageUrl: String?
  var previewThumb: CHPreviewThumb?
}

extension CHWebPage: Mappable {
  init?(map: Map) {

  }
  mutating func mapping(map: Map) {
    url          <- map["url"]
    title        <- map["title"]
    description  <- map["description"]
    imageUrl     <- map["imageUrl"]
    previewThumb <- map["previewThumb"]
  }
}

extension CHWebPage: Equatable {}

func ==(lhs: CHWebPage, rhs: CHWebPage) -> Bool {
  return lhs.url == rhs.url && lhs.title == rhs.title
}
