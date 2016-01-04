//
//  HomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation
import Moscapsule
import Alamofire
import ReachabilitySwift


// MARK: HomeClient protocol

protocol HomeClient {
    func publish(topic: String, message: String)
    func publish(topic: String, message: String, completion: ((HomeClientStatus) -> ()))
    
    func connect()
    func disconnect()
}


enum HomeClientStatus {
    case Success
    case Failure
}


// MARK: Network auto-switching HomeClient

class SwitchingHomeClient: NSObject, HomeClient {
    
    var realClient: HomeClient = HttpHomeClient()
    var localServerReachable: Reachability?, internetReachable: Reachability?
    var listening: Bool = false
    
    private func startListening() {
        do {
            let mqttServerHost = userDefaults().stringForKey("mqtt_host")!
            localServerReachable = try Reachability(hostname: mqttServerHost)
            
            internetReachable = try Reachability.reachabilityForInternetConnection()

            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification,
                object: localServerReachable
            )
            
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
    
    func reachabilityChanged(notification: NSNotification) {
        let reachability = notification.object as! Reachability
        
        if reachability.isReachableViaWiFi() {
            self.switchToLocalConnection()
        } else {
            self.switchToProxyConnection()
        }
    }
    
    private func switchToLocalConnection() {
        if let _ = realClient as? HttpHomeClient {
            NSLog("Local server became reachable")
            self.realClient.disconnect()
            self.realClient = MqttHomeClient()
            self.realClient.connect()
        }
    }
    
    private func switchToProxyConnection() {
        if let _ = realClient as? MqttHomeClient {
            NSLog("Local server became unreachable")
            self.realClient.disconnect()
            self.realClient = HttpHomeClient()
            self.realClient.connect()
        }
    }
    
    // HomeClient protocol implementation

    func publish(topic: String, message: String) {
        realClient.publish(topic, message: message)
    }
    
    func publish(topic: String, message: String, completion: ((HomeClientStatus) -> ())) {
        if(internetReachable!.isReachable()) {
            realClient.publish(topic, message: message, completion: completion)
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


// MARK: MQTT HomeClient

class MqttHomeClient: NSObject, HomeClient {
    var mqtt: MQTTClient?
    
    let qos: Int32 = 2 // The broker/client will deliver the message exactly once by using a four step handshake.
    
    func publish(topic: String, message: String) {
        mqtt?.publishString(message, topic: topic, qos: qos, retain: false)
    }
    
    func publish(topic: String, message: String, completion: ((HomeClientStatus) -> ())) {
        mqtt?.publishString(message, topic: topic, qos: qos, retain: false, requestCompletion: { (result, _) in
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


// MARK: HTTP proxied HomeClient

class HttpHomeClient: NSObject, HomeClient {
    var apiURL: String?
    
    func publish(topic: String, message: String) {
        NSLog("httpHomeClient publish")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message
        ])
    }
    
    func publish(topic: String, message: String, completion: ((HomeClientStatus) -> ())) {
        NSLog("httpHomeClient publish with callback")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message
        ]).responseJSON { response in
            if response.result.isSuccess {
                completion(HomeClientStatus.Success)
            } else {
                completion(HomeClientStatus.Failure)
            }
        }
    }
    
    func connect() {
        // We cannot access the preferences in init() yet
        apiURL = userDefaults().stringForKey("api_mqtt_url")!
        // No connection necessary
        NSLog("HTTP connecting")
    }
    
    func disconnect() {
        // No disconnection necessary
        NSLog("HTTP disconnecting")
    }
}