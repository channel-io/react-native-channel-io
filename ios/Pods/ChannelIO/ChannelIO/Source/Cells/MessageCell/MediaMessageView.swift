//
//  CHMImageView.swift
//  CHPlugin
//
//  Created by Haeun Chung on 16/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import NVActivityIndicatorView
import M13ProgressSuite
import DKImagePickerController
import SnapKit
import SDWebImage

class MediaMessageView : BaseView {

  //MARK: properties
  
  let imageView = FLAnimatedImageView()
  var placeholder: UIImage?
  
  static var imageMaxSize: CGSize = {
    let screenSize = UIScreen.main.bounds.size
    return CGSize(width: screenSize.width * 2 / 3, height: screenSize.height / 2)
  }()
  
  static var imageDefaultSize: CGSize = {
    let screenSize = UIScreen.main.bounds.size
    return CGSize(width: screenSize.width / 2, height: screenSize.height / 4)
  }()
  
  fileprivate var imageSize = imageDefaultSize

  var indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44)).then {
    $0.type = .ballRotateChase
    $0.color = CHColors.light
    $0.startAnimating()
  }
  
  var progressView = M13ProgressViewRing().then {
    $0.showPercentage = false
    $0.primaryColor = UIColor.white
    $0.secondaryColor = UIColor.white
  }
  
  //MARK: methods
  
  override func initialize() {
    super.initialize()
    self.layer.cornerRadius = 6.f
    self.layer.borderWidth = 1.0
    self.layer.borderColor = CHColors.darkTwo.cgColor
    self.clipsToBounds = true
    
    self.addSubview(self.imageView)
    self.addSubview(self.indicatorView)
    self.addSubview(self.progressView)
  }
  
  func configure(message: MessageCellModelType, isThumbnail: Bool) {
    guard let file = message.file else { return }
    guard file.image == true else { return }
    
    if message.isFailed {
      self.progressView.isHidden = true
      self.indicatorView.isHidden = true
    }
    
    if message.progress == 1 {
      self.progressView.isHidden = true
      self.indicatorView.isHidden = false
      self.indicatorView.startAnimating()
    }
    
    if let asset = file.asset, message.progress != 1.0 {
      self.indicatorView.isHidden = true
      self.progressView.isHidden = false
      
      asset.fetchOriginalImageWithCompleteBlock({
        [weak self] (image, info) in

        self?.imageView.alpha = 0.4
        self?.imageView.image = image
        self?.placeholder = image
      })
      
      //change to delegation to update ui rather using redux
      self.progressView.setProgress(message.progress, animated: false)
      
    } else if let image = file.imageData, message.progress != 1.0 {
      self.indicatorView.isHidden = true
      self.progressView.isHidden = false
      self.imageView.alpha = 0.4
      self.imageView.image = image
      self.placeholder = image
      
      self.progressView.setProgress(message.progress, animated: false)
    } else {
      self.indicatorView.isHidden = false
      self.progressView.isHidden = true
      
      let urlString = isThumbnail ? file.previewThumb?.url ?? "" : file.url
      let url = URL(string: urlString)
      
      if file.asset == nil {
        self.placeholder = nil
      }
      
      self.imageView.sd_setImage(with: url, completed: { [weak self] (image, error, cacheType, url) in
        self?.imageView.alpha = 1
        self?.indicatorView.stopAnimating()
      })
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    
    self.imageView.snp.makeConstraints { (make) in
      make.edges.equalToSuperview()
    }
    
    self.progressView.snp.remakeConstraints { (make) in
      make.width.equalTo(44)
      make.height.equalTo(44)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
    
    self.indicatorView.snp.remakeConstraints { (make) in
      make.width.equalTo(44)
      make.height.equalTo(44)
      make.centerX.equalToSuperview()
      make.centerY.equalToSuperview()
    }
  }
  
  func setProgress(value: CGFloat) {
    self.progressView.setProgress(value, animated: true)
  }

  class func getThumbnailImageSize(imageSize: CGSize) -> CGSize {
    let ratio = max(imageSize.width / imageMaxSize.width, imageSize.height / imageMaxSize.height)
    if ratio >= 1.0 {
      return CGSize(width: imageSize.width / ratio, height: imageSize.height / ratio)
    } else {
      return imageSize
    }
  }

  class func viewSize(fits width: CGFloat, viewModel: MessageCellModelType) -> CGSize {
    if let previewThumb = viewModel.file?.previewThumb {
      return getThumbnailImageSize(imageSize: CGSize(width: previewThumb.width, height: previewThumb.height))
    }
    
    var size = imageDefaultSize
    if let asset = viewModel.file?.asset {
      asset.fetchOriginalImage(true, completeBlock: { (image, info) in
        size = getThumbnailImageSize(imageSize: image?.size ?? CGSize.zero)
      })
    } else if let image = viewModel.file?.imageData {
      size = getThumbnailImageSize(imageSize: image.size)
    }

    return size
  }
}
