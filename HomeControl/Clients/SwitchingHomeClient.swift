//
//  SwitchingHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 09/05/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import Promissum
import RxSwift
import Reachability

internal class ProxyHomeClient: HomeClient {
  fileprivate var instance: HomeClient

  init(instance: HomeClient) {
    self.instance = instance
  }

  func publish(_ message: Message) -> Promise<Message, HomeClientError> {
    return instance.publish(message)
  }

  func subscribe(_ topic: Topic) -> Observable<Message> {
    return instance.subscribe(topic)
  }

  func connect() -> Promise<Void, HomeClientError> {
    return instance.connect()
  }

  func disconnect() {
    return instance.disconnect()
  }
}

class SwitchingHomeClient: ProxyHomeClient {
  let userDefaults: Foundation.UserDefaults

  let internetReachability: Reachability
  let localReachability: Reachability

  var connectionState: ConnectionState

  enum ConnectionState {
    case localnetwork
    case remoteproxy
  }

  typealias LocalClient = MqttHomeClient
  typealias RemoteClient = HttpHomeClient

  init(userDefaults: Foundation.UserDefaults = Foundation.UserDefaults.standard) {
    self.userDefaults = userDefaults

    internetReachability = Reachability(hostName: userDefaults.string(forKey: "api_mqtt_url")!)
    localReachability = Reachability(hostName: userDefaults.string(forKey: "mqtt_host")!)

    connectionState = .localnetwork

    super.init(instance: HttpHomeClient(mqttWebProxyUrl: userDefaults.string(forKey: "api_mqtt_url")!))

    localReachability.reachableBlock = self.switchToLocalNetwork
    localReachability.reachableOnWWAN = false
    internetReachability.reachableBlock = self.switchToRemoteNetwork

    internetReachability.startNotifier()
    localReachability.startNotifier()
  }

  fileprivate func swapInstanceFor(_ newInstance: HomeClient) {
    let oldClient = instance
    newInstance.connect().then {
      self.instance = newInstance
    }.finally {
      oldClient.disconnect()
    }
  }

  fileprivate func switchToLocalNetwork(reachability: Reachability?) {
    if instance is LocalClient { return }
    swapInstanceFor(RemoteClient())
    connectionState = .remoteproxy
    print("switched to LocalNetwork")
  }

  fileprivate func switchToRemoteNetwork(reachability: Reachability?) {
    if instance is RemoteClient { return }
    swapInstanceFor(LocalClient())
    connectionState = .localnetwork
    print("switchToRemoteNetwork")
  }

  deinit {
    internetReachability.stopNotifier()
    localReachability.stopNotifier()
  }
}
