//
//  WebpageView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 16/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import SDWebImage
import SnapKit

class WebPageMessageView : BaseView {
  struct Metric {
    static let imageHeight = 120.f // TODO: support dynamic height?
  }
  
  struct Font {
    static let titleLabel = UIFont.systemFont(ofSize: 13)
    static let descLabel = UIFont.systemFont(ofSize: 11)
  }
  
  struct Color {
    static let titleLabel = CHColors.dark
    static let descLabel = CHColors.gray
  }
  
  let thumbnailImageView = UIImageView().then {
    $0.contentMode = UIViewContentMode.scaleAspectFill
    $0.clipsToBounds = true
  }
  
  let detailView = UIView()
  
  let titleLabel = UILabel().then {
    $0.font = Font.titleLabel
    $0.textColor = Color.titleLabel
  }
  
  let descLabel = UILabel().then {
    $0.font = Font.descLabel
    $0.textColor = Color.descLabel
  }
  
  var imageWidth  = 0.0
  var imageHeight = 0.0
  var imageUrl = ""
  
  override func initialize() {
    super.initialize()
    self.layer.cornerRadius = 6
    self.layer.borderWidth = 1.0
    self.layer.borderColor = CHColors.darkTwo.cgColor
    self.clipsToBounds = true
    
    self.addSubview(self.thumbnailImageView)
    self.addSubview(self.detailView)
    self.detailView.addSubview(self.titleLabel)
    self.detailView.addSubview(self.descLabel)
  }
  
  func configure(message: MessageCellModelType) {
    self.imageUrl = message.webpage?.previewThumb?.url ?? ""
    self.thumbnailImageView.isHidden = self.imageUrl == ""
    
    if self.imageUrl != "" {
      let url = URL(string: self.imageUrl)
      self.thumbnailImageView.sd_setImage(with: url)
    }
    
    self.titleLabel.text = message.webpage?.title ?? ""
    self.descLabel.text = message.webpage?.description ?? ""
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.thumbnailImageView.snp.remakeConstraints { [weak self] (make) in
      if self?.imageUrl != "" {
        make.top.equalToSuperview()
        make.leading.equalToSuperview()
        make.trailing.equalToSuperview()
        make.height.equalTo(Metric.imageHeight)
      } else {
        make.height.equalTo(0)
      }
    }
    
    self.detailView.snp.remakeConstraints { [weak self] (make) in
      if self?.imageUrl == "" {
        make.top.equalToSuperview()
      } else {
        make.top.equalTo((self?.thumbnailImageView.snp.bottom)!)
      }
      
      if self?.titleLabel.text != "" && self?.descLabel.text != "" {
        make.height.equalTo(60)
      } else if ((self?.titleLabel.text == "" && self?.descLabel.text != "") ||
        (self?.titleLabel.text != "" && self?.descLabel.text == "")) {
        make.height.equalTo(40)
      } else {
        make.height.equalTo(0)
      }
      
      make.leading.equalToSuperview()
      make.trailing.equalToSuperview()
      make.bottom.equalToSuperview()
    }
    
    self.titleLabel.snp.remakeConstraints { [weak self] (make) in
      if self?.titleLabel.text != "" {
        make.top.equalToSuperview().inset(12)
        make.right.equalToSuperview().inset(12)
        make.left.equalToSuperview().inset(12)
      }
    }
    
    self.descLabel.snp.remakeConstraints { [weak self] (make) in
      if self?.descLabel.text != "" {
        make.left.equalToSuperview().inset(12)
        make.right.equalToSuperview().inset(12)
        make.bottom.equalToSuperview().inset(13)
      }
    }
  }

  class func viewHeight(fits width: CGFloat, webpage: CHWebPage?) -> CGFloat {
    var viewHeight : CGFloat = 0.0

    // add preview height
    if webpage?.previewThumb?.url != nil {
      viewHeight += Metric.imageHeight
    }

    // add title, desc height
    let title = webpage?.title ?? ""
    let desc = webpage?.description ?? ""

    if title.isEmpty && !desc.isEmpty {
      viewHeight += 40
    } else if !title.isEmpty && desc.isEmpty {
      viewHeight += 40
    } else if title.isEmpty && desc.isEmpty {
      //0
    } else {
      viewHeight += 60
    }

    return viewHeight
  }

}
