//
//  Message.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import UIKit
import MQTTClient

struct Message {
  static let encoding = NSUTF8StringEncoding

  enum QoS {
    case AtMostOnce
    case AtLeastOnce
    case ExactlyOnce

    static func fromMqttQoS(mqttQos: MQTTQosLevel) -> QoS {
      switch mqttQos {
      case .AtLeastOnce: return QoS.AtLeastOnce
      case .ExactlyOnce: return QoS.ExactlyOnce
      case .AtMostOnce:  return QoS.AtMostOnce
      }
    }
  }

  let topic: Topic
  let payload: NSData?
  let qos: QoS
  let retain: Bool

  init(topic: Topic, payload: NSData? = nil, qos: QoS = .AtLeastOnce, retain: Bool = false) {
    self.topic = topic
    self.payload = payload
    self.qos = qos
    self.retain = retain
  }

  init(topic: Topic, payloadString: String? = nil, qos: QoS = .AtLeastOnce, retain: Bool = false) {
    self.topic = topic
    self.payload = payloadString?.dataUsingEncoding(Message.encoding)
    self.qos = qos
    self.retain = retain
  }

  func asBoolean() -> Bool? {
    guard let payload = payloadString else { return nil }
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
    guard let payload = payloadString else { return nil }
    return Float(payload)
  }

  func asColor() -> UIColor? {
    return .clearColor()
  }
}

extension Message {
  var payloadString: String? {
    guard let data = payload else { return nil }
    return String(data: data, encoding: Message.encoding)
  }

  var mqttQos: MQTTQosLevel {
    switch qos {
    case .AtLeastOnce: return MQTTQosLevel.AtLeastOnce
    case .ExactlyOnce: return MQTTQosLevel.ExactlyOnce
    case .AtMostOnce:  return MQTTQosLevel.AtMostOnce
    }
  }
}