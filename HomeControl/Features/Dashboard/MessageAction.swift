//
//  MessageAction.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation

struct MessageAction {
  // Description of the action for the user
  let description: String

  // The message to be sent by this action
  var message: Message

  let type: ActionType

  init(topic: Topic, payload: String?, description: String, type: ActionType = .PushButton) {
    self.message = Message(topic: topic, payloadString: payload)
    self.description = description
    self.type = type
  }

  init(message: Message, description: String, type: ActionType = .PushButton) {
    self.message = message
    self.description = description
    self.type = type
  }
}

enum ActionType {
  case PushButton
  case ToggleSwitch
  case Display
}

//enum ValueType {
//  case Number(value: Float)
//  case Boolean(value: Bool)
//  case Fraction(teller: Int, noemer: Int)
//}