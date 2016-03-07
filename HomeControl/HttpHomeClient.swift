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
  
  func publish(topic: String, message: String, retain: Bool = false) {
    NSLog("httpHomeClient publish")
    
    Alamofire.request(.POST, apiURL!, parameters: [
      "topic": topic,
      "message": message,
      "retain": retain
    ])
  }

  func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ())) {
    NSLog("httpHomeClient publish with callback")

    Alamofire.request(.POST, apiURL!, parameters: [
      "topic": topic,
      "message": message,
      "retain": retain
    ]).responseJSON { response in
      if response.result.isSuccess {
        completion(.Success)
      } else {
        completion(.Failure)
      }
    }
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