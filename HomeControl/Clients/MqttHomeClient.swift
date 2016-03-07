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
  var mqtt: MQTTClient?
  
  let qos: Int32 = 2 // The broker/client will deliver the message exactly once by using a four step handshake.
  
  func publish(topic: String, message: String, retain: Bool = false) {
    mqtt?.publishString(message, topic: topic, qos: qos, retain: retain)
  }
  
  func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ())) {
    mqtt?.publishString(message, topic: topic, qos: qos, retain: retain, requestCompletion: { (result, _) in
      NSLog("result")
      if result == MosqResult.MOSQ_SUCCESS {
        completion(HomeClientStatus.Success)
      } else {
        completion(HomeClientStatus.Failure)
      }
    })
  }
  
  func connect() {
    let mqttConfig = MQTTConfig(
      clientId: userDefaults().stringForKey("mqtt_client_id")!,
      host: userDefaults().stringForKey("mqtt_host")!,
      port: Int32(userDefaults().integerForKey("mqtt_port")),
      keepAlive: 60
    )
    
    // Create new MQTT Connection
    mqtt = MQTT.newConnection(mqttConfig)
    NSLog("MQTT connecting")
  }
  
  func disconnect() {
    NSLog("MQTT disconnecting")
    mqtt?.disconnect()
  }
  
  deinit {
    disconnect()
  }
}
