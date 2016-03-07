//
//  SwitchingHomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/02/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation
import ReachabilitySwift

class SwitchingHomeClient: HomeClient {
  
  var realClient: HomeClient = HttpHomeClient()
  var localServerReachable: Reachability?, internetReachable: Reachability?
  var listening: Bool = false
  
  private func startListening() {
    do {
      let mqttServerHost = userDefaults().stringForKey("mqtt_host")!
      localServerReachable = try Reachability(hostname: mqttServerHost)
      
      internetReachable = try Reachability.reachabilityForInternetConnection()
      
//      NSNotificationCenter.defaultCenter().addObserver(self,
//        selector: "reachabilityChanged:",
//        name: ReachabilityChangedNotification,
//        object: localServerReachable
//      )

      try localServerReachable?.startNotifier()
      
      listening = true
      NSLog("Started listening for connectivity")
    } catch {
      NSLog("Unable to create or start Reachability.")
    }
  }
  
  private func stopListening() {
    localServerReachable?.stopNotifier()
    NSNotificationCenter.defaultCenter().removeObserver(self,
      name: ReachabilityChangedNotification,
      object: localServerReachable
    )
  }
  
  deinit {
    stopListening()
  }
  
  func reachabilityChanged(notification: AnyObject?) { // NSNotification
    guard let notification = notification as? NSNotification else { return }
    guard let reachability = notification.object as? Reachability else { return }
    
    if reachability.isReachableViaWiFi() {
      self.switchToLocalConnection()
    } else {
      self.switchToProxyConnection()
    }
  }
  
  private func switchToLocalConnection() {
    NSLog("Local server became reachable")
    self.realClient.disconnect()
    self.realClient = MqttHomeClient()
    self.realClient.connect()
  }
  
  private func switchToProxyConnection() {
    NSLog("Local server became unreachable")
    self.realClient.disconnect()
    self.realClient = HttpHomeClient()
    self.realClient.connect()
  }
  
  // HomeClient protocol implementation
  
  func publish(topic: String, message: String, retain: Bool) {
    realClient.publish(topic, message: message, retain: retain)
  }
  
  func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ())) {
    if(internetReachable!.isReachable()) {
      realClient.publish(topic, message: message, retain: retain, completion: completion)
    } else {
      completion(HomeClientStatus.Failure)
    }
  }
  
  func connect() {
    realClient.connect()
    if !listening {
      self.startListening()
    }
  }
  
  func disconnect() {
    realClient.disconnect()
  }
}
