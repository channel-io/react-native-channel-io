//
//  MessageCellModel.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 9..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit

enum ClipType {
  case None
  case File
  case Image
  case Webpage
}

protocol MessageCellModelType {
  var name: String { get }
  var timestamp: String { get }
  var timestampIsHidden: Bool { get }
  var message: CHMessage { get }
  var avatarEntity: CHEntity { get }
  var avatarIsHidden: Bool { get }
  var bubbleBackgroundColor: UIColor { get }
  var textColor: UIColor { get }
  var usernameIsHidden: Bool { get }
  var imageIsHidden: Bool { get }
  var fileIsHidden: Bool { get }
  var webpageIsHidden: Bool { get }
  var webpage: CHWebPage? { get }
  var file: CHFile? { get }
  var createdByMe: Bool { get }
  var isContinuous: Bool { get }
  var messageType: MessageType { get }
  var progress: CGFloat { get }
  var isFailed: Bool { get }
  var profileItems: [CHProfileItem] { get set }
  var currentIndex: Int { get set }
  var totalCount: Int { get set }
  var pluginColor: UIColor { get }
  var shouldDisplayForm: Bool { get set }
  var selectedActionText: String { get set }
  var translateState: CHMessageTranslateState { get set }
  var showTranslation: Bool { get }
}

struct MessageCellModel: MessageCellModelType {
  let name: String
  let timestamp: String
  let timestampIsHidden: Bool
  let message: CHMessage
  let avatarEntity: CHEntity
  let avatarIsHidden: Bool
  let bubbleBackgroundColor: UIColor
  let textColor: UIColor
  let usernameIsHidden: Bool
  let imageIsHidden: Bool
  let fileIsHidden: Bool
  let webpageIsHidden: Bool
  let webpage: CHWebPage?
  let file: CHFile?
  let createdByMe: Bool
  let isContinuous: Bool
  let messageType: MessageType
  let progress: CGFloat
  let isFailed: Bool
  let pluginColor: UIColor
  
  var profileItems: [CHProfileItem]
  var currentIndex: Int
  var totalCount: Int
  
  var shouldDisplayForm: Bool
  var selectedActionText: String = ""
  
  var showTranslation: Bool = false
  var translateState: CHMessageTranslateState = .original
  
  init(message: CHMessage, previous: CHMessage?, indexPath: IndexPath? = nil) {
    let channel = mainStore.state.channel
    let plugin = mainStore.state.plugin
    let isContinuous = message.isContinue(previous: previous) &&
      previous?.form == nil && previous?.profileBot == nil &&
      message.form == nil
    let pluginColor = UIColor(plugin.color) ?? UIColor.white
    let clipType = MessageCellModel.getClipType(message: message)
    let createdByMe = message.entity is CHUser || message.entity is CHVeil

    self.name = message.entity?.name ?? ""
    self.timestamp = message.readableCreatedAt
    self.timestampIsHidden = isContinuous
    self.message = message
    self.avatarEntity = message.entity ?? channel
    self.avatarIsHidden = createdByMe || isContinuous
    self.bubbleBackgroundColor = createdByMe ? pluginColor : CHColors.lightGray
    self.textColor = plugin.textUIColor
    self.usernameIsHidden = createdByMe || isContinuous
    self.imageIsHidden = (clipType != ClipType.Image)
    self.fileIsHidden = (clipType != ClipType.File)
    self.webpageIsHidden = (clipType != ClipType.Webpage)
    self.webpage = message.webPage
    self.file = message.file
    self.createdByMe = createdByMe
    self.isContinuous = isContinuous
    self.pluginColor = pluginColor
    
    self.messageType = message.messageType
    self.progress = message.progress
    self.isFailed = message.state == .Failed
    
    //profileBot
    self.profileItems = message.profileBot ?? []
    if let index = self.profileItems.index(where: { (profileItem) -> Bool in
      return profileItem.value == nil
    }) {
      self.currentIndex = index
    } else {
      self.currentIndex = self.profileItems.count - 1
    }
    self.totalCount = self.profileItems.count //max 4
    
    //form : select
    self.shouldDisplayForm = message.form != nil && indexPath?.row == 0 && message.form?.closed == false
    
    self.showTranslation =
      message.language != "" &&
      message.language != CHUtils.getLocale()?.rawValue &&
      mainStore.state.userChatsState.showTranslation &&
      !createdByMe
    self.translateState = message.translateState
  }

  static func getClipType(message: CHMessage) -> ClipType {
    if message.file?.isPreviewable == true || message.file?.asset != nil {
      return .Image
    } else if message.file != nil {
      return .File
    } else if message.webPage != nil {
      return .Webpage
    } else {
      return .None
    }
  }

}
