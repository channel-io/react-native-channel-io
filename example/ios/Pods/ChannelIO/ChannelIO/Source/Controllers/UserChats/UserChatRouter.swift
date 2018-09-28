//
//  UserChatRouter.swift
//  CHPlugin
//
//  Created by Haeun Chung on 27/03/2018.
//  Copyright © 2018 ZOYI. All rights reserved.
//

import UIKit
import RxSwift
import DKImagePickerController
import AVKit

class UserChatRouter: NSObject, UserChatRouterProtocol {
//  func presentImageViewer(with url: URL?, photoUrls: [URL], from view: UIViewController?, dataSource: MWPhotoBrowserDelegate) {
//    guard let url = url else { return }
//    let index = photoUrls.index { (photoUrl) -> Bool in
//      return photoUrl.absoluteString == url.absoluteString
//    }
//
//    let browser = MWPhotoBrowser(delegate: dataSource)
//    browser?.zoomPhotosToFill = false
//
//    let navigation = MainNavigationController(rootViewController: browser!)
//    if index != nil {
//      browser?.setCurrentPhotoIndex(UInt(index!))
//    }
//    view?.present(navigation, animated: true, completion: nil)
//  }
  
  func presentVideoPlayer(with url: URL?, from view: UIViewController?) {
    guard let url = url else { return }
    
    let moviePlayer = AVPlayerViewController()
    let player = AVPlayer(url: url)
    moviePlayer.player = player
    moviePlayer.modalPresentationStyle = .overFullScreen
    moviePlayer.modalTransitionStyle = .crossDissolve
    view?.present(moviePlayer, animated: true, completion: nil)
  }
  
  func presentSettings(from view: UIViewController?) {
    let controller = ProfileViewController()
    let navigation = MainNavigationController(rootViewController: controller)
    view?.navigationController?.present(navigation, animated: true, completion: nil)
  }
  
  func showNewChat(with text: String, from view: UINavigationController?) {
    view?.popViewController(animated: false, completion: {
      let controller = UserChatRouter.createModule(userChatId: nil)
      _ = controller.presenter?.readyToDisplay()?.subscribe(onNext: { ready in
        if ready {
          view?.pushViewController(controller, animated: false)
        }
      })
    })
  }
  
  static func createModule(userChatId: String?) -> UserChatView {
    let view = UserChatView()
    
    let presenter = UserChatPresenter()
    let interactor = UserChatInteractor()
    presenter.router = UserChatRouter()
    presenter.interactor = interactor
    
    view.presenter = presenter
    return view
  }
  
  func showOptionActionSheet(from view: UIViewController?) -> Observable<[DKAsset]> {
    return Observable.create({ (subscriber) in
      let alertView = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
      
      alertView.addAction(
        UIAlertAction(title: CHAssets.localized("ch.camera"), style: .default) { [weak self] _ in
          _ = self?.showOptionPicker(type: .camera, from: view).subscribe(onNext: { asset in
            subscriber.onNext(asset)
          })
      })
      
      alertView.addAction(
        UIAlertAction(title: CHAssets.localized("ch.photo.album"), style: .default) { [weak self] _ in
          _ = self?.showOptionPicker(type: .photo, max: 20, from: view).subscribe(onNext: { (assets) in
            subscriber.onNext(assets)
          })
      })
      
      alertView.addAction(
        UIAlertAction(title: CHAssets.localized("ch.chat.resend.cancel"), style: .cancel) { _ in
          //nothing
      })
      
      CHUtils.getTopNavigation()?.present(alertView, animated: true, completion: nil)
      return Disposables.create()
    })
   
  }
  
  func showOptionPicker(
    type: DKImagePickerControllerSourceType,
    max: Int = 0,
    assetType: DKImagePickerControllerAssetType = .allPhotos, from view: UIViewController?) -> Observable<[DKAsset]> {
    return Observable.create({ (subscriber) in
      let pickerController = DKImagePickerController()
      pickerController.sourceType = type
      pickerController.showsCancelButton = true
      pickerController.maxSelectableCount = max
      pickerController.assetType = assetType
      pickerController.didSelectAssets = { (assets: [DKAsset]) in
        subscriber.onNext(assets)
        subscriber.onCompleted()
      }
      
      view?.present(pickerController, animated: true, completion: nil)
      return Disposables.create()
    })
  }
  
  func showRetryActionSheet(from view: UIViewController?) -> Observable<Bool?> {
    return Observable.create({ (subscriber) in
      let alertView = UIAlertController(title:nil, message:nil, preferredStyle: .actionSheet)
      alertView.addAction(UIAlertAction(title: CHAssets.localized("ch.chat.retry_sending_message"), style: .default) {  _ in
        subscriber.onNext(true)
      })
      
      alertView.addAction(UIAlertAction(title: CHAssets.localized("ch.chat.delete"), style: .destructive) {  _ in
        subscriber.onNext(false)
      })
      
      alertView.addAction(UIAlertAction(title: CHAssets.localized("ch.chat.resend.cancel"), style: .cancel) { _ in
        subscriber.onNext(nil)
      })
      
      CHUtils.getTopController()?.present(alertView, animated: true, completion: nil)
      return Disposables.create()
    })
  }
}

extension UserChatRouter : UIDocumentInteractionControllerDelegate {
  func pushFileView(with url: URL?, from view: UIViewController?) {
    guard let url = url, let view = view else { return }
    
    let docController = UIDocumentInteractionController(url: url)
    docController.delegate = self
    
    if !docController.presentPreview(animated: true) {
      docController.presentOptionsMenu(
        from: view.bounds, in: view.view, animated: true)
    }
  }
  
  func documentInteractionControllerViewControllerForPreview(
    _ controller: UIDocumentInteractionController) -> UIViewController {
    if let controller = CHUtils.getTopController() {
      return controller
    }
    return UIViewController()
  }
}
