//
//  MqttHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Moscapsule

class MqttHomeClient: HomeClient {
  private var mqtt: MQTTClient?
  
  private let keepAlive: Int32 = 60

  private var listeners = [HomeClientListener]()

  private var userDefaults = NSUserDefaults.standardUserDefaults()
  
  func publish(message: Message) {
    mqtt?.publishString(message.payload ?? "", topic: message.topic, qos: Int32(message.qos), retain: message.retain)
  }
  
  func publish(message: Message, completion: HomeClientStatus -> Void) {
    mqtt?.publishString(message.payload ?? "", topic: message.topic, qos: Int32(message.qos), retain: message.retain, requestCompletion: { (result, _) in
      if result == MosqResult.MOSQ_SUCCESS {
        completion(HomeClientStatus.Success)
      } else {
        completion(HomeClientStatus.Failure)
      }
    })
  }

  func subscribe(topic: Topic, listener: HomeClientListener) {
    listeners.append(listener)
    mqtt?.subscribe(topic, qos: 2)
  }

  func unsubscribe(topic: Topic) {
    mqtt?.unsubscribe(topic)
  }
  
  func connect() {
    let mqttConfig = MQTTConfig(
      clientId: userDefaults.stringForKey("mqtt_client_id")!,
      host: userDefaults.stringForKey("mqtt_host")!,
      port: Int32(userDefaults.integerForKey("mqtt_port")),
      keepAlive: keepAlive
    )
    
    // Create new MQTT Connection
    mqtt = MQTT.newConnection(mqttConfig)
    NSLog("MQTT connecting")
  }
  
  func disconnect() {
    NSLog("MQTT disconnecting")
    mqtt?.disconnect()
  }
}
