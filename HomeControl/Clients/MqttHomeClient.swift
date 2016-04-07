//
//  MqttHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Moscapsule
import RxSwift
import Promissum

class MqttHomeClient: HomeClient {
  private var mqtt: MQTTClient?
  private var mqttMessages: Observable<Message>?
  
  private let keepAlive: Int32 = 60

  private var userDefaults = NSUserDefaults.standardUserDefaults()

  func publish(message: Message) -> Promise<HomeClientStatus, ErrorType> {
    let source = PromiseSource<HomeClientStatus, ErrorType>()
    mqtt?.publishString(message.payload ?? "", topic: message.topic, qos: Int32(message.qos), retain: message.retain, requestCompletion: { (result, _) in
      if result == MosqResult.MOSQ_SUCCESS {
        source.resolve(.Success)
      } else {
        source.reject(HomeClientError(message: "Could not publish to MQTT"))
      }
    })
    return source.promise
  }

  func subscribe(topic: Topic) -> Observable<Message> {
    print("subscribing to \(topic)")
    guard let mqttMessages = mqttMessages else {
      fatalError()
    }
    return mqttMessages
  }

//  private func onMessage(mqttMessage: MQTTMessage) {
//    let message = Message(mqttMessage: mqttMessage)
//    print("message was received on topic: \(message.topic) payload: \(message.payload)")
//  }

  func unsubscribe(topic: Topic) {
    print("unsubscribed from \(topic)")
//    mqtt?.unsubscribe(topic)
  }
  
  func connect() {
    let mqttConfig = MQTTConfig(
      clientId: userDefaults.stringForKey("mqtt_client_id")!,
      host: userDefaults.stringForKey("mqtt_host")!,
      port: Int32(userDefaults.integerForKey("mqtt_port")),
      keepAlive: keepAlive
    )

    mqttMessages = Observable<Message>.create { observer in
      mqttConfig.onMessageCallback = { mqttMessage in
        print("received a message in root observable!")
        observer.on(.Next(Message(mqttMessage: mqttMessage)))
      }
      return RefCountDisposable(disposable: AnonymousDisposable {
        mqttConfig.onMessageCallback = { _ in }
      })
    }
    
    // Create new MQTT Connection
    mqtt = MQTT.newConnection(mqttConfig)
    NSLog("MQTT connecting")
  }
  
  func disconnect() {
    NSLog("MQTT disconnecting")
    mqtt?.disconnect()
  }
}
