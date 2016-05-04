//
//  MessageActionCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 07/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import Promissum

protocol SendsMessages {
  var homeClient: HomeClient? { get set }
  var action: MessageViewModel? { get set }
}

extension SendsMessages {
  func sendCurrentMessage() -> Promise<Message, HomeClientError> {

    guard let homeClient = homeClient else {
      let source = PromiseSource<Message, HomeClientError>()
      source.reject(HomeClientError(message: "SendsMessages: no client"))
      return source.promise
    }
    guard let action = action else {
      let source = PromiseSource<Message, HomeClientError>()
      source.reject(HomeClientError(message: "SendsMessages: no action"))
      return source.promise
    }
    
    return homeClient.publish(action.message)
  }
}