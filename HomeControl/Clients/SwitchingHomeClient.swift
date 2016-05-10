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
  private var instance: HomeClient

  init(instance: HomeClient) {
    self.instance = instance
  }

  func publish(message: Message) -> Promise<Message, HomeClientError> {
    return instance.publish(message)
  }

  func subscribe(topic: Topic) -> Observable<Message> {
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
  let userDefaults: NSUserDefaults

  let internetReachability: Reachability
  let localReachability: Reachability

  typealias LocalClient = MqttHomeClient
  typealias RemoteClient = HttpHomeClient

  init(userDefaults: NSUserDefaults = NSUserDefaults.standardUserDefaults()) {
    self.userDefaults = userDefaults

    internetReachability = Reachability(hostName: userDefaults.stringForKey("api_mqtt_url")!)
    localReachability = Reachability(hostName: userDefaults.stringForKey("mqtt_host")!)

    super.init(instance: HttpHomeClient(userDefaults: userDefaults))

    localReachability.reachableBlock = self.switchToLocalNetwork
    localReachability.reachableOnWWAN = false
    internetReachability.reachableBlock = self.switchToRemoteNetwork

    internetReachability.startNotifier()
    localReachability.startNotifier()
  }

  private func swapInstanceFor(newInstance: HomeClient) {
    let oldClient = instance
    newInstance.connect().then {
      self.instance = newInstance
    }.finally {
      oldClient.disconnect()
    }
  }

  private func switchToLocalNetwork(reachability: Reachability!) {
    if instance is LocalClient { return }
    swapInstanceFor(RemoteClient())
    print("switchToLocalNetwork")
  }

  private func switchToRemoteNetwork(reachability: Reachability!) {
    if instance is RemoteClient { return }
    swapInstanceFor(LocalClient())
    print("switchToRemoteNetwork")
  }

  deinit {
    internetReachability.stopNotifier()
    localReachability.stopNotifier()
  }
}