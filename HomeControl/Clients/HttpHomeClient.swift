//
//  HttpHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Alamofire
import Promissum
import RxSwift

class HttpHomeClient: HomeClient {
  let mqttWebProxyUrl: String

  convenience init(userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
    self.init(mqttWebProxyUrl: userDefaults.stringForKey("api_mqtt_url")!)
  }

  init(mqttWebProxyUrl: String) {
    self.mqttWebProxyUrl = mqttWebProxyUrl
  }

  func publish(message: Message) -> Promise<Message, HomeClientError> {
    print("httpHomeClient publish")

    return Alamofire.request(.POST, mqttWebProxyUrl, parameters: [
      "topic": message.topic,
      "message": message.payloadString ?? "",
      "retain": message.retain
    ])
      .responsePromise()
      .mapError { error in
        return HomeClientError(message: "HTTP Networking error")
      }
      .map { _ in
        return message
      }
  }

  func subscribe(topic: Topic) -> Observable<Message> {
    fatalError("Not implmemented")
  }

  func connect() -> Promise<Void, HomeClientError> {
    let source = PromiseSource<Void, HomeClientError>()
    source.resolve()
    return source.promise
  }

  func disconnect() {
    //
  }
}