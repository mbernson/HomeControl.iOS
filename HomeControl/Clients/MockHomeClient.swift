//
//  MockHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 11/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

class MockHomeClient: HomeClient {
  func publish(message: Message) {
    print("MockHomeClient published a message")
    print("topic: '\(message.topic)'")
    print("message: '\(message.payload)'")
    print("retain: '\(message.retain)'")
  }

  func publish(message: Message, completion: HomeClientStatus -> Void) {
    print("MockHomeClient published a message with callback")
    print("topic: '\(message.topic)'")
    print("message: '\(message.payload)'")
    print("retain: '\(message.retain)'")
    completion(HomeClientStatus.Success)
  }

  func subscribe(topic: Topic, listener: HomeClientListener) {
    fatalError("Not implmemented")
  }

  func unsubscribe(topic: Topic) {
    fatalError("Not implmemented")
  }
  
  func connect() {
    print("MockHomeClient connected")
  }
  
  func disconnect() {
    print("MockHomeClient disconnected")
  }
}

