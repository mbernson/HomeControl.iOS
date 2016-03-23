//
//  MessageAction.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation

struct MessageAction {
  let message: Message
  let description: String
  let type: ActionType = .PushButton

  init(topic: String, message: String, description: String) {
    self.message = Message(topic: topic, payload: message, qos: 2, retain: false)
    self.description = description
  }

  func currentState() -> Bool? {
    switch message.payload.lowercaseString {
    case "on", "yes", "true":
      return true
    case "off", "no", "false":
      return false
    default:
      return nil
    }
  }
}

enum ActionType {
  case PushButton
  case ToggleSwitch
}

enum ValueType {
  case Number(value: Float)
  case Fraction(teller: Int, noemer: Int)
}