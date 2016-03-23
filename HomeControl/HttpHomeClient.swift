//
//  HttpHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Alamofire

class HttpHomeClient: HomeClient {
  lazy var apiURL: String? = {
    return userDefaults().stringForKey("api_mqtt_url")
  }()
  
  func publish(message: Message) {
    NSLog("httpHomeClient publish")
    
    Alamofire.request(.POST, apiURL!, parameters: [
      "topic": message.topic,
      "message": message.payload,
      "retain": message.retain
    ])
  }

  func publish(message: Message, completion: HomeClientStatus -> Void) {
    NSLog("httpHomeClient publish with callback")

    Alamofire.request(.POST, apiURL!, parameters: [
      "topic": message.topic,
      "message": message.payload,
      "retain": message.retain
    ]).responseJSON { response in
      if response.result.isSuccess {
        completion(.Success)
      } else {
        completion(.Failure)
      }
    }
  }

  func subscribe(topic: Topic, listener: HomeClientListener) {
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