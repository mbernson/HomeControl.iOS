//
//  MessageAction.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation

struct MessageAction {
  // The message to be sent by this action
  var message: Message
  // Description of the action for the user
  let description: String
  // 
  let type: ActionType

  init(topic: Topic, payload: String?, type: ActionType, description: String) {
    self.message = Message(topic: topic, payload: payload, qos: 2, retain: false)
    self.description = description
    self.type = type
  }

  init(message: Message, type: ActionType, description: String) {
    self.message = message
    self.description = description
    self.type = type
  }
}

enum ActionType {
  case PushButton
  case ToggleSwitch
  case Gauge
}

enum ValueType {
  case Number(value: Float)
  case Fraction(teller: Int, noemer: Int)
}