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
  static let encoding = String.Encoding.utf8

  enum QoS {
    case atMostOnce
    case atLeastOnce
    case exactlyOnce

    static func fromMqttQoS(_ mqttQos: MQTTQosLevel) -> QoS {
      switch mqttQos {
      case .atLeastOnce: return QoS.atLeastOnce
      case .exactlyOnce: return QoS.exactlyOnce
      case .atMostOnce:  return QoS.atMostOnce
      }
    }
  }

  let topic: Topic
  let payload: Data?
  let qos: QoS
  let retain: Bool

  init(topic: Topic, payload: Data? = nil, qos: QoS = .atLeastOnce, retain: Bool = false) {
    self.topic = topic
    self.payload = payload
    self.qos = qos
    self.retain = retain
  }

  init(topic: Topic, payloadString: String? = nil, qos: QoS = .atLeastOnce, retain: Bool = false) {
    self.topic = topic
    self.payload = payloadString?.data(using: Message.encoding)
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
    return UIColor.clear
  }
}

extension Message {
  var payloadString: String? {
    guard let data = payload else { return nil }
    return String(data: data, encoding: Message.encoding)
  }

  var mqttQos: MQTTQosLevel {
    switch qos {
    case .atLeastOnce: return MQTTQosLevel.atLeastOnce
    case .exactlyOnce: return MQTTQosLevel.exactlyOnce
    case .atMostOnce:  return MQTTQosLevel.atMostOnce
    }
  }
}
