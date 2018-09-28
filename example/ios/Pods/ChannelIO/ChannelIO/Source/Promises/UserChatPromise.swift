//
//  UserChatPromise.swift
//  CHPlugin
//
//  Created by Haeun Chung on 06/02/2017.
//  Copyright © 2017 ZOYI. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON
import ObjectMapper

struct UserChatPromise {
  static func getChats(since:Int64?=nil, limit:Int, showCompleted: Bool = false) -> Observable<[String: Any?]> {
    return Observable.create { subscriber in
      var params = ["query": [
          "limit": limit,
          "includeClosed": showCompleted
        ]
      ]
      if since != nil {
        params["query"]?["since"] = since
      }

      Alamofire.request(RestRouter.GetUserChats(params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            //next, managers, sessions, userChats, messages
            let next = json["next"].int64Value
            let managers = Mapper<CHManager>().mapArray(JSONObject: json["managers"].object)
            let sessions = Mapper<CHSession>().mapArray(JSONObject: json["sessions"].object)
            let userChats = Mapper<CHUserChat>().mapArray(JSONObject: json["userChats"].object)
            let messages = Mapper<CHMessage>().mapArray(JSONObject: json["messages"].object)
            let bots = Mapper<CHBot>().mapArray(JSONObject: json["bots"].object)
            
            subscriber.onNext([
              "next":next,
              "managers": managers,
              "sessions": sessions,
              "userChats": userChats,
              "messages": messages,
              "bots": bots
            ])
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func createChat(pluginId: String) -> Observable<ChatResponse> {
    return Observable.create { subscriber in

      Alamofire.request(RestRouter.CreateUserChat(pluginId))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
                subscriber.onError(CHErrorPool.chatResponseParseError)
                break
            }
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create()
    }
  }
  static func getChat(userChatId: String) -> Observable<ChatResponse> {
    return Observable.create { subscriber in
      Alamofire.request(RestRouter.GetUserChat(userChatId))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let chatResponse = Mapper<ChatResponse>()
              .map(JSONObject: json.object) else {
              subscriber.onError(CHErrorPool.chatResponseParseError)
              break
            }
            
            subscriber.onNext(chatResponse)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
          
        })
      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func close(userChatId: String, formId: String) -> Observable<CHUserChat> {
    return Observable.create { subscriber in
      let params = ["query":["formId": formId]]
      let req = Alamofire.request(RestRouter.CloseUserChat(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let userChat = Mapper<CHUserChat>().map(JSONObject: json["userChat"].object) else {
              subscriber.onError(CHErrorPool.userChatParseError)
              break
            }
            
            subscriber.onNext(userChat)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
      }
      return Disposables.create {
        req.cancel()
      }
    }
  }
  
  static func review(userChatId: String, formId: String, rating: ReviewType) -> Observable<CHUserChat> {
    return Observable.create { subscriber in
      let params = [
        "url":["review": rating.rawValue],
        "query":["formId": formId]
      ]
      
      let req = Alamofire.request(RestRouter.ReviewUserChat(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let userChat = Mapper<CHUserChat>().map(JSONObject: json["userChat"].object) else {
              subscriber.onError(CHErrorPool.userChatParseError)
              break
            }
            
            subscriber.onNext(userChat)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
      }
      return Disposables.create {
        req.cancel()
      }
    }
  }

  static func remove(userChatId: String) -> Observable<Any?> {
    return Observable.create { subscriber in
      let req = Alamofire.request(RestRouter.RemoveUserChat(userChatId))
        .validate(statusCode: 200..<300)
        .responseJSON { response in
          if response.response?.statusCode == 200 {
            subscriber.onNext(nil)
            subscriber.onCompleted()
          } else {
            subscriber.onError(CHErrorPool.userChatRemoveError)
          }
        }
      return Disposables.create {
        req.cancel()
      }
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func getMessages(
    userChatId: String,
    since: String,
    limit: Int,
    sortOrder: String) -> Observable<[String: Any]> {
    return Observable.create { subscriber in
      let params = [
        "query": [
          "since": since,
          "limit": limit,
          "sortOrder": sortOrder
        ]
      ]
      
      let req = Alamofire.request(RestRouter.GetMessages(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)

            guard let messages: Array<CHMessage> =
              Mapper<CHMessage>().mapArray(JSONObject: json["messages"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }

            guard let managers: Array<CHManager> =
              Mapper<CHManager>().mapArray(JSONObject: json["managers"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }
            
            guard let bots: Array<CHBot> =
              Mapper<CHBot>().mapArray(JSONObject: json["bots"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }
            
            let prev = json["previous"].string ?? ""
            let next = json["next"].string ?? ""
            
            subscriber.onNext([
              "messages": messages,
              "managers": managers,
              "bots": bots,
              "previous": prev,
              "next": next
            ])
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create {
        req.cancel()
      }
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func createMessage(
    userChatId: String,
    message: String,
    requestId: String,
    submit: CHSubmit? = nil) -> Observable<CHMessage> {
    return Observable.create { subscriber in
      var params = [
        "body": [String: AnyObject]()
      ]
      
      params["body"]?["message"] = message as AnyObject?
      params["body"]?["requestId"] = requestId as AnyObject?
      
      if let submit = submit {
        params["body"]?["submit"] = submit.toJSON() as AnyObject?
      }
      
      let req = Alamofire.request(RestRouter.CreateMessage(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { response in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let message = Mapper<CHMessage>()
              .map(JSONObject: json["message"].object) else {
              subscriber.onError(CHErrorPool.messageParseError)
              break
            }
            
            subscriber.onNext(message)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create {
        req.cancel()
      }
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }

  static func updateMessageProfile(messageId: String, key: String, value: Any) -> Observable<CHMessage> {
    return Observable.create { subscriber in
      let params = [
        "body": [
          key: value
        ]
      ]
      
      let req = Alamofire.request(RestRouter.UpdateProfileItem(messageId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { (response) in
          switch response.result {
          case .success(let data):
            let json = JSON(data)
            guard let message = Mapper<CHMessage>()
              .map(JSONObject: json["message"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
            }
            
            subscriber.onNext(message)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create {
        req.cancel()
      }
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func uploadFile(
    name: String? = nil,
    file: Data,
    requestId: String,
    userChatId: String,
    mimeType: Mimetype) -> Observable<CHMessage> {
    //validate category to make sure it can be handled
    return Observable.create { subscriber in
      let params: [String: Any] = [:]
      
      let requestIdData = requestId.data(using: String.Encoding.utf8, allowLossyConversion: false)
      let request = RestRouter.UploadFile(userChatId, params as RestRouter.ParametersType)
      
      Alamofire.upload(
        multipartFormData: { formData in
          formData.append(file, withName: "file",
                          fileName: name ?? "Channel_File",
                          mimeType: mimeType.rawValue)
          formData.append(requestIdData!, withName: "requestId")
        },
        to: (request.urlRequest?.url?.absoluteString)!,
        headers: request.urlRequest?.allHTTPHeaderFields,
        encodingCompletion: { (encodingResult) in
        switch encodingResult {
        case .success(let upload, _, _):
          upload.uploadProgress(closure: { progress in
            dlog("upload progress \(progress.fractionCompleted)")
            guard var message = messageSelector(state: mainStore.state, id: requestId) else { return }
            if (CGFloat(progress.fractionCompleted) - message.progress) > 0.1 && message.progress != 1.0{
              message.progress = CGFloat(progress.fractionCompleted)
              mainStore.dispatch(UpdateMessage(payload: message))
            }
          })
          
          upload.responseData(completionHandler: { (response) in
            switch response.result {
            case .success(let data):
              let json = JSON(data)
              guard let message = Mapper<CHMessage>()
                .map(JSONObject: json["message"].object) else {
                subscriber.onError(CHErrorPool.messageParseError)
                break
              }
              
              subscriber.onNext(message)
              subscriber.onCompleted()
            case .failure(let error):
              subscriber.onError(error)
            }
          })
          break
        case .failure:
          subscriber.onError(CHErrorPool.uploadError)
        }
      })

      return Disposables.create()
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func setMessageRead(userChatId: String, at: Date? = nil) -> Observable<Any?> {
    return Observable.create { subscriber in
      guard let readAt = CustomDateTransform().transformToJSON(at) else {
        return Disposables.create()
      }
      
      let params: [String: Any] = [
        "query": [ "at" : readAt ]
      ]
      
      let req = Alamofire.request(RestRouter.SetMessagesRead(userChatId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .response(completionHandler: { (response) in
          if response.response?.statusCode == 200 {
            subscriber.onNext(nil)
            subscriber.onCompleted()
          } else {
            subscriber.onError(CHErrorPool.readAllError)
          }
        })
      return Disposables.create {
        req.cancel()
      }
    }.subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
  
  static func translate(messageId: String, language: String) -> Observable<String?> {
    return Observable.create({ (subscriber) in
      let params = [
        "query": [
          "language": language
        ]
      ]
      let req = Alamofire.request(RestRouter.Translate(messageId, params as RestRouter.ParametersType))
        .validate(statusCode: 200..<300)
        .responseJSON(completionHandler: { (response) in
          switch response.result {
          case .success(let data):
            let json = SwiftyJSON.JSON(data)
            let text = json["text"].string
            
            subscriber.onNext(text)
            subscriber.onCompleted()
          case .failure(let error):
            subscriber.onError(error)
          }
        })
      return Disposables.create {
        req.cancel()
      }
    }).subscribeOn(ConcurrentDispatchQueueScheduler(qos:.background))
  }
}
