//
//  UserChatPresenter.swift
//  CHPlugin
//
//  Created by Haeun Chung on 26/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import RxSwift
import DKImagePickerController
import UIKit
import SVProgressHUD

class UserChatPresenter: NSObject, UserChatPresenterProtocol {
  weak var view: UserChatViewProtocol? = nil
  var interactor: UserChatInteractorProtocol? = nil
  var router: UserChatRouterProtocol? = nil
  
  var userChatId: String?
  var userChat: CHUserChat?
  
  var disposeBag = DisposeBag()
  
  func viewDidLoad() {
    //fetchWelcomeInfoIfNeeded
    self.refreshChat()
      
    self.interactor?.chatEventSignal()
      .observeOn(MainScheduler.instance)
      .subscribe (onNext: { [weak self] chatEvent in
        switch chatEvent {
        case .messages(let messages, _):
          //self?.userChat?.readAll()
          self?.view?.display(messages: messages)
        case .manager(_):
          break
        case .chat(_):
          self?.refreshChat()
//          if chat?.isResolved() == true {
//            //self.view?.updateInputField(userChat: self?.userChat, updatedUserChat: chat)
//            //display resolved
//          } else if chat?.isClosed() == true {
//            //display closed
//          }
        case .typing(let typers, _):
          self?.view?.display(typers: typers)
        default:
          break
        }
        
      }).disposed(by: self.disposeBag)
  }

  func prepareDataSource() {
    self.interactor?.subscribeDataSource()
  }
  
  func cleanDataSource() {
    self.interactor?.unsunbscribeDataSource()
    self.interactor?.sendTyping(isStop: true)
  }
  
  func reload() {
    
  }
  
//  func resetUserChat() -> Observable<String?> {
//    return Observable.create({ [weak self] (subscribe) in
//      //guard let s = self else { return Disposables.create() }
//      self?.nextSeq = ""
//      var signal: Disposable?
//      
//      if let chatId = self?.chatId, chatId != "" {
//        signal = self?.fetchChat().subscribe(onNext: { _ in
//          mainStore.dispatch(RemoveMessages(payload: chatId))
//          subscribe.onNext(chatId)
//        }, onError: { error in
//          subscribe.onError(error)
//        })
//      } else {
//        signal = self?.createChat().subscribe(onNext: { chatId in
//          subscribe.onNext(chatId)
//        }, onError: { error in
//          subscribe.onError(error)
//        })
//      }
//      
//      return Disposables.create {
//        signal?.dispose()
//      }
//    })
//  }
//  

  //presenter
  private func isNewChat(with current: CHUserChat?, nextUserChat: CHUserChat?) -> Bool {
    return self.userChat == nil && nextUserChat == nil
  }
}

extension UserChatPresenter {
  func didClickOnFeedback(rating: String, from view: UIViewController?) {
    self.interactor?.sendFeedback(rating: rating)
  }
  
  func didClickOnOption(from view: UIViewController?) {
    guard let interactor = self.interactor else { return }
    
    self.router?.showOptionActionSheet(from: view).subscribe(onNext: { [weak self] assets in
      let messages = assets.map({ (asset) -> CHMessage in
        return CHMessage(chatId: self?.userChatId ?? "", guest: mainStore.state.guest, asset: asset)
      })
      
      if let userChatId = self?.userChatId, userChatId != "" {
        interactor.send(messages: messages).subscribe(onNext: { (_) in
          
        }, onError: { (error) in
          
        }).disposed(by: (self?.disposeBag)!)
      } else {
        interactor.createChat().flatMap({ (chat) -> Observable<Any?> in
          return interactor.send(messages: messages)
        }).flatMap({ (completed) -> Observable<Bool?> in
          return interactor.requestProfileBot()
        }).subscribe(onNext: { (completed) in
          
        }, onError: { (error) in
          
        }).disposed(by: (self?.disposeBag)!)
      }
    }).disposed(by: self.disposeBag)
  }

  func didClickOnRetry(for message: CHMessage?, from view: UIViewController?) {
    guard let interactor = self.interactor else { return }
    
    self.router?.showRetryActionSheet(from: view).subscribe(onNext: { retry in
      if retry == true {
        _ = interactor.send(message: message).subscribe()
      } else if retry == false {
        interactor.delete(message: message)
      }
    }).disposed(by: self.disposeBag)
  }
  
  func didClickOnManager(from view: UIViewController?) { }
  func didClickOnVideo(with url: URL?, from view: UIViewController?) {
    guard let url = url else { return }
    self.router?.presentVideoPlayer(with: url, from: view)
  }
  
  func didClickOnFile(with message: CHMessage?, from view: UIViewController?) {
    guard var message = message else { return }
    guard let file = message.file else { return }
    
    if file.category == "video" {
      self.didClickOnVideo(with: file.fileUrl!, from: view)
      return
    }
    
    SVProgressHUD.showProgress(0)
    file.download().observeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] (fileURL, progress) in
        if let fileURL = fileURL {
          SVProgressHUD.dismiss()
          message.file?.urlInDocumentsDirectory = fileURL
          mainStore.dispatch(UpdateMessage(payload: message))
          self?.router?.pushFileView(with: fileURL, from: view)
        }
        if progress < 1 {
          SVProgressHUD.showProgress(progress)
        }
      }, onError: { (error) in
          SVProgressHUD.dismiss()
      }, onCompleted: {
        SVProgressHUD.dismiss()
      }).disposed(by: self.disposeBag)
  }
  
  func didClickOnImage(with url: URL?, from view: UIViewController?) {

  }

  func didClickOnWeb(with url: String?, from view: UIViewController?) {
    guard let url = URL(string: url ?? "") else { return }
    UIApplication.shared.openURL(url)
  }
  
  func didClickOnTranslate(for message: CHMessage?) {
    guard let message = message else { return }
    self.interactor?.translate(for: message)
  }
  
  func didClickOnNewChat(with text: String, from view: UINavigationController?) {
    self.router?.showNewChat(with: text, from: view)
  }
  
  func didClickOnSettings(from view: UIViewController?) {
    self.router?.presentSettings(from: view)
  }
  
  func readyToDisplay() -> Observable<Bool>? {
    return self.interactor?.readyToPresent()
  }

  func fetchMessages() {
    guard self.interactor?.canLoadMore() == true else { return }
    self.interactor?.fetchMessages()
  }
  
  func didClickOnRightButton(text: String, assets: [DKAsset]) {
    guard let interactor = self.interactor else { return }
    guard let chatId = self.userChatId else { return }
    let guest = mainStore.state.guest
    
    var messages = assets.enumerated().map { (index, asset) -> CHMessage in
      if index == 0 {
        return CHMessage(chatId: chatId, guest: guest, message: text, asset: asset)
      }
      return CHMessage(chatId: chatId, guest: guest, asset: asset)
    }
    
    if messages.count == 0 {
      messages = [CHMessage(chatId: chatId, guest: guest, message: text)]
    }
    
    if let userChat = self.userChat, userChat.isActive() {
      interactor.send(messages: messages).subscribe().disposed(by: self.disposeBag)
    } else if self.userChat == nil {
      interactor.createChat().flatMap({ (userChat) -> Observable<Any?> in
        return interactor.send(messages: messages)
      }).flatMap({ (messages) -> Observable<Bool?> in
        return interactor.requestProfileBot()
      }).subscribe(onNext: { (completed) in
        
      }, onError: { (error) in
        
      }).disposed(by: self.disposeBag)
    }
    else {
      mainStore.dispatch(RemoveMessages(payload: userChatId))
      //open new chat if text
      //self.newChatSubject.onNext(self.textView.text)
    }
  }
  
  func didClickOnMessageButton(originId: String?, key: String?, value: String?) {
    guard let originId = originId, let key = key, let value = value else { return }
    guard let interactor = self.interactor else { return }
    
    interactor.send(text: value, originId: originId, key: key)
      .subscribe(onNext: { [weak self] (message) in
      self?.view?.display(messages: [])
    }, onError: { [weak self] (error) in
      self?.view?.display(error: error, visible: true)
    }).disposed(by: self.disposeBag)
  }
  
  func send(text: String, assets: [DKAsset]) {

  }
  
  func sendTyping(isStop: Bool) {
    self.interactor?.sendTyping(isStop: isStop)
  }
}

extension UserChatPresenter {
  func refreshChat() {
    let userChat = userChatSelector(state: mainStore.state, userChatId: self.userChatId)
    let userChats = userChatsSelector(
      state: mainStore.state,
      showCompleted: mainStore.state.userChatsState.showCompletedChats
    )
    
    self.view?.setChatInfo(info: UserChatInfo(
      userChat: userChat,
      channel: mainStore.state.channel,
      plugin: mainStore.state.plugin,
      managers: [],
      showSettings: userChats.count == 0,
      textColor: mainStore.state.plugin.textUIColor))
  }
}
