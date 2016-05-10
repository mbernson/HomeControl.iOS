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
    var observer: AnyObserver<Message>!

    init(observer: AnyObserver<Message>) {
      print("MqttHomeDelegate init")
      self.observer = observer
    }

    deinit {
      print("MqttHomeDelegate deinit")
    }

    func newMessage(session: MQTTSession!, data: NSData!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
      let message = Message(topic: topic, payload: data, qos: Message.QoS.fromMqttQoS(qos), retain: retained)
      print("received a message on topic \(topic) with content \(message.payloadString)")
      observer.on(.Next(message))
    }

    func subAckReceived(session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
      print("subscribe acknowledged")
    }

    func unsubAckReceived(session: MQTTSession!, msgID: UInt16) {
      print("unsubscribe acknowledged")
    }
  }

  let mqttSession: MQTTSession
  let messages: Observable<Message>
  var currentObserver: AnyObserver<Message>?
  var topics = [Topic]()

  convenience init(userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
    let host = userDefaults.stringForKey("mqtt_host")!
    let port = UInt16(userDefaults.integerForKey("mqtt_port"))
    self.init(host: host, port: port)
  }

  init(host: String, port: UInt16) {
    let mqttTransport: MQTTCFSocketTransport
    let mqttSession: MQTTSession
    var delegate: MqttHomeDelegate? = nil
    var currentObserver: AnyObserver<Message>? = nil

    mqttTransport = MQTTCFSocketTransport()
    mqttTransport.host = host
    mqttTransport.port = port

    mqttSession = MQTTSession()
    mqttSession.transport = mqttTransport

    self.mqttSession = mqttSession
    self.messages = Observable.create { observer in
      delegate = MqttHomeDelegate(observer: observer)
      mqttSession.delegate = delegate
      currentObserver = observer

      return AnonymousDisposable {
        print("disposing mqttsession!")
        mqttSession.disconnect()
      }
    }.shareReplay(1) // This line is important!
    self.currentObserver = currentObserver
  }

  deinit {
    print("mqtthomeclient deinit")
  }

  func connect() -> Promise<Void, HomeClientError> {
    let source = PromiseSource<Void, HomeClientError>()
    mqttSession.connectHandler = { error in
      if error != nil {
        source.reject(HomeClientError(message: error.description))
      } else {
        for topic in self.topics {
          self.mqttSession.subscribeToTopic(topic, atLevel: .AtLeastOnce)
        }
        source.resolve()
      }
    }

    mqttSession.connect()

    return source.promise
  }

  func disconnect() {
    mqttSession.disconnect()
  }

  func publish(message: Message) -> Promise<Message, HomeClientError> {
    let publish = PromiseSource<Message, HomeClientError>()
    mqttSession.publishData(message.payload, onTopic: message.topic, retain: message.retain, qos: message.mqttQos) { [weak self] error in
      if error != nil {
        publish.reject(HomeClientError(message: error.description))
      } else {
        print("published message '\(message.payloadString)' on topic '\(message.topic)'")
        self?.currentObserver?.on(.Next(message))
        publish.resolve(message)
      }
    }
    return publish.promise
  }

  func subscribe(topic: Topic) -> Observable<Message> {
    // Tell the broker that we're interested in a new topic
    mqttSession.subscribeToTopic(topic, atLevel: .AtLeastOnce) { (error, qos) in
      if error != nil {
        print("subscribing failed!")
      } else {
        print("subscribed to topic \(topic), granted QoS of \(qos)")
      }
    }

    topics.append(topic)

    return messages.filter { message in
      return message.topic == topic
    }
  }
  
}