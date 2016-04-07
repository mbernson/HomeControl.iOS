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
  private var userDefaults = NSUserDefaults.standardUserDefaults()

  func publish(message: Message) -> Promise<HomeClientStatus, ErrorType> {
    print("httpHomeClient publish")

    Alamofire.request(.POST, userDefaults.stringForKey("api_mqtt_url")!, parameters: [
      "topic": message.topic,
      "message": message.payload ?? "",
      "retain": message.retain
    ])
    return Promise(value: HomeClientStatus.Success)
  }

  func subscribe(topic: Topic) -> Observable<Message> {
    fatalError("Not implmemented")
  }

  func unsubscribe(topic: Topic) {
    fatalError("Not implmemented")
  }

  func connect() {
    // No connection necessary
    NSLog("HTTP connecting")
  }
  
  func disconnect() {
    // No disconnection necessary
    NSLog("HTTP disconnecting")
  }
}