//
//  MqttHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Promissum
import RxSwift
import MQTTClient

class MqttHomeClient: HomeClient {

  class MqttHomeDelegate: NSObject, MQTTSessionDelegate {
    let observer: AnyObserver<Message>

    init(observer: AnyObserver<Message>) {
      print("MqttHomeDelegate init")
      self.observer = observer
      super.init()
    }

    deinit {
      print("MqttHomeDelegate deinit")
    }

    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
      print("received a message on topic \(topic)!")
      let message = Message(topic: topic, payload: data, qos: Message.QoS.fromMqttQoS(qos), retain: retained)
      observer.on(.Next(message))
    }

  }

  let mqttTransport: MQTTCFSocketTransport
  let mqttSession: MQTTSession

  let messages: Observable<Message>

  init() {
    let mqttTransport: MQTTCFSocketTransport
    let mqttSession: MQTTSession
    var delegate: MqttHomeDelegate?

    mqttTransport = MQTTCFSocketTransport()
    mqttTransport.host = "localhost"
    mqttTransport.port = 1883

    mqttSession = MQTTSession(clientId: "homecontrol-app")
    mqttSession.transport = mqttTransport

    let observable: Observable<Message> = Observable.create { observer in
      delegate = MqttHomeDelegate(observer: observer)
      mqttSession.delegate = delegate

      return RefCountDisposable(disposable: AnonymousDisposable {
        print("disposing the mqttsession!")
        mqttSession.disconnect()
      })
    }

    self.mqttSession = mqttSession
    self.mqttTransport = mqttTransport
    self.messages = observable
  }

  func connect() -> Promise<Void, HomeClientError> {
    let source = PromiseSource<Void, HomeClientError>()
    mqttSession.connectHandler = { error in
      if error != nil {
        source.reject(HomeClientError(message: error.description))
      } else {
        source.resolve()
      }
    }
    print("mqtt connecting...")
    mqttSession.connect()
    return source.promise
  }

  func disconnect() {
    print("mqtt disconnecting...")
    mqttSession.disconnect()
  }

  func publish(message: Message) -> Promise<Message, HomeClientError> {
    let publish = PromiseSource<Message, HomeClientError>()
    mqttSession.publishData(message.payload, onTopic: message.topic, retain: message.retain, qos: message.mqttQos) { error in
      if error != nil {
        publish.reject(HomeClientError(message: error.description))
      } else {
        print("published message '\(message.payloadString)' on topic '\(message.topic)'")
        publish.resolve(message)
      }
    }
    return publish.promise
  }

  func subscribe(topic: Topic) -> Observable<Message> {
    mqttSession.subscribeToTopic(topic, atLevel: .AtLeastOnce) { (error, qos) in
      if error != nil {
        print("subscribing failed!")
      } else {
        print("subscribed to topic '\(topic)' with qos \(qos)")
      }
    }

    return messages.filter { message in
      return message.topic == topic
    }
  }
  
}