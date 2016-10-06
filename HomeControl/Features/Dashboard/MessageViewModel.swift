//
//  MessageViewModel.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation

struct MessageViewModel {
  // Description of the action for the user
  let description: String

  // The message to be sent by this action
  var message: Message

  let type: ActionType

  init(topic: Topic, payload: String? = nil, description: String, type: ActionType) {
    self.message = Message(topic: topic, payloadString: payload)
    self.description = description
    self.type = type
  }

  init(message: Message, description: String, type: ActionType) {
    self.message = message
    self.description = description
    self.type = type
  }
}

enum ActionType {
  case button
  case toggle
  case display // (ValueType)
//  case Color
}

enum ValueType {
  case integer
  case float
  case boolean
  case text
}
