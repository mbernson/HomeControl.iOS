//
//  MockHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 11/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

class MockHomeClient: HomeClient {
  func publish(topic: String, message: String, retain: Bool) {
    print("MockHomeClient published a message")
    print("topic: '\(topic)'")
    print("message: '\(message)'")
    print("retain: '\(retain)'")
  }
  func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ())) {
    print("MockHomeClient published a message with callback")
    print("topic: '\(topic)'")
    print("message: '\(message)'")
    print("retain: '\(retain)'")
    completion(HomeClientStatus.Success)
  }
  
  func connect() {
    print("MockHomeClient connected")
  }
  
  func disconnect() {
    print("MockHomeClient disconnected")
  }
}

