//
//  Message.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Moscapsule

struct Message {
  let topic: String
  var payload: String?
  let qos: Int32
  let retain: Bool

  func asBoolean() -> Bool? {
    guard let payload = payload else { return nil }
    switch payload {
    case "on", "yes", "1", "true":
      return true
    case "off", "no", "0", "false":
      return false
    default:
      print("failed to convert payload '\(payload)' to a boolean")
      return nil
    }
  }

  func asNumber() -> Float? {
    guard let payload = payload else { return nil }
    return Float(payload)
  }

//  func asColor() -> UIColor?
}

extension Message {
  init(mqttMessage: MQTTMessage) {
    topic = mqttMessage.topic
    payload = mqttMessage.payloadString
    qos = mqttMessage.qos
    retain = mqttMessage.retain
  }
}