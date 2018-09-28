//
//  UserChatsEmptyView.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 3. 30..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import SnapKit

class UserChatsEmptyView: BaseView {

  // MARK: Constants

  struct Font {
    static let description = UIFont.boldSystemFont(ofSize: 14)
  }

  struct Color {
    static let description = CHColors.blueyGrey
  }

  // MARK: Properties

  let imageView = UIImageView().then {
    $0.image = CHAssets.getImage(named: "group")
  }

  let descriptionLabel = UILabel().then {
    $0.numberOfLines = 0
    $0.font = Font.description
    $0.textColor = Color.description
    $0.text = CHAssets.localized("ch.chat.empty_description")
    $0.textAlignment = .center
  }

  // MARK: Initializing

  override func initialize() {
    super.initialize()
    self.backgroundColor = UIColor.white
    self.addSubview(self.imageView)
    self.addSubview(self.descriptionLabel)
  }

  // MARK: Layout

  override func layoutSubviews() {
    super.layoutSubviews()

    self.imageView.snp.remakeConstraints { (make) in
      make.size.equalTo(CGSize(width: 80, height: 80))
      make.bottom.equalTo(self.snp.centerY)
      make.centerX.equalToSuperview()
    }

    self.descriptionLabel.snp.remakeConstraints { (make) in
      make.top.equalTo(self.snp.centerY).offset(28)
      make.centerX.equalToSuperview()
      make.leading.equalToSuperview().inset(20)
      make.trailing.equalToSuperview().inset(20)
    }
  }
}
