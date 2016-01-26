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
    func publish(topic: String, message: String, retain: Bool)
    func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ()))
    
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


// MARK: MQTT HomeClient

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


// MARK: HTTP proxied HomeClient

class HttpHomeClient: HomeClient {
    var apiURL: String?
    
    func publish(topic: String, message: String, retain: Bool = false) {
        NSLog("httpHomeClient publish")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message,
            "retain": retain
        ])
    }
    
    func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ())) {
        NSLog("httpHomeClient publish with callback")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message,
            "retain": retain
        ]).responseJSON { response in
            if response.result.isSuccess {
                completion(.Success)
            } else {
                completion(.Failure)
            }
        }
    }
    
    func connect() {
        // We cannot access the preferences yet when init() runs...
        apiURL = userDefaults().stringForKey("api_mqtt_url")!
        
        // No connection necessary
        NSLog("HTTP connecting")
    }
    
    func disconnect() {
        // No disconnection necessary
        NSLog("HTTP disconnecting")
    }
}