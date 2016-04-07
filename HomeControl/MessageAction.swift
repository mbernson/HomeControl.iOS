//
//  MessageAction.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation

protocol MessageAction {
  var description: String { get }
  func nextMessage() -> Message
}

struct StandardMessageAction: MessageAction {
  // The message to be sent by this action
  let message: Message
  // Description of the action for the user
  let description: String

  init(topic: Topic, payload: String?, description: String) {
    self.message = Message(topic: topic, payload: payload, qos: 2, retain: false)
    self.description = description
  }

  init(message: Message, description: String) {
    self.message = message
    self.description = description
  }

  func nextMessage() -> Message {
    return message
  }
}

enum ActionType {
  case PushButton
  case ToggleSwitch
  case Gauge
}

enum ValueType {
  case Number(value: Float)
  case Boolean(value: Bool)
  case Fraction(teller: Int, noemer: Int)
}