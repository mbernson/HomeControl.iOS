//
//  Client.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation
import Moscapsule
import Alamofire
import ReachabilitySwift
import SystemConfiguration

// MARK: Client protocol

protocol Client {
    func publish(topic: String, message: String)
    func publish(topic: String, message: String, completion: ((ClientStatus) -> ()))
    
    func connect(options: NSDictionary)
    func disconnect()
}


enum ClientStatus {
    case Success
    case Failure
}

// MARK: Network auto-switching client

class SwitchingClient: NSObject, Client {
    
    var actualClient: Client
    var localServerReachable: Reachability?, internetReachable: Reachability?
    var lastUsedOptions: NSDictionary?
    var listening: Bool = false
    
    override init() {
        actualClient = HttpClient()
        super.init()
    }
    
    deinit {
        stopListening()
    }
    
    private func startListening() {
        do {
            let mqttServerHost = prefString("mqtt_host")
            localServerReachable = try Reachability(hostname: mqttServerHost)
            
            internetReachable = try Reachability.reachabilityForInternetConnection()
            
//            localServerReachable?.whenReachable = self.switchToLocalConnection
//            localServerReachable?.whenUnreachable = self.switchToProxyConnection

            NSNotificationCenter.defaultCenter().addObserver(self,
                selector: "reachabilityChanged:",
                name: ReachabilityChangedNotification,
                object: localServerReachable)
            
            try localServerReachable?.startNotifier()
            
            listening = true
            NSLog("Started listening for connectivity")
        } catch {
            NSLog("Unable to create Reachability.")
        }
    }
    
    private func stopListening() {
        localServerReachable?.stopNotifier()
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
        if let _ = actualClient as? HttpClient {
            NSLog("Local server became reachable")
            self.actualClient.disconnect()
            self.actualClient = AMQTTClient()
            self.actualClient.connect(lastUsedOptions!)
        }
    }
    
    private func switchToProxyConnection() {
        if let _ = actualClient as? AMQTTClient {
            NSLog("Local server became unreachable")
            self.actualClient.disconnect()
            self.actualClient = HttpClient()
            self.actualClient.connect(lastUsedOptions!)
        }
    }

    func publish(topic: String, message: String) {
        actualClient.publish(topic, message: message)
    }
    
    func publish(topic: String, message: String, completion: ((ClientStatus) -> ())) {
        if(internetReachable!.isReachable()) {
            actualClient.publish(topic, message: message, completion: completion)
        } else {
            completion(ClientStatus.Failure)
        }
    }
    
    func connect(options: NSDictionary) {
        lastUsedOptions = options
        actualClient.connect(options)
        if !listening {
            self.startListening()
        }
    }
    
    func disconnect() {
        actualClient.disconnect()
    }
}

// MARK: MQTT client

class AMQTTClient: NSObject, Client {
    var mqttClient: MQTTClient?
    
    func publish(topic: String, message: String) {
        assert(mqttClient != nil, "Not connected to MQTT yet!")
        mqttClient?.publishString(message, topic: topic, qos: 2, retain: false)
    }
    
    func publish(topic: String, message: String, completion: ((ClientStatus) -> ())) {
        assert(mqttClient != nil, "Not connected to MQTT yet!")
        mqttClient?.publishString(message, topic: topic, qos: 2, retain: false, requestCompletion: { (result, _) in
            NSLog("result")
            if result == MosqResult.MOSQ_SUCCESS {
                completion(ClientStatus.Success)
            } else {
                completion(ClientStatus.Failure)
            }
        })
    }
    
    func connect(options: NSDictionary) {
        let mqttConfig = MQTTConfig(clientId: prefString("mqtt_client_id"), host: prefString("mqtt_host"), port: Int32(prefInt("mqtt_port")), keepAlive: 60)
        
        mqttConfig.onPublishCallback = { messageId in
            NSLog("published (mid=\(messageId))")
        }
        
        mqttConfig.onMessageCallback = { mqttMessage in
            NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
        }
        
        // create new MQTT Connection
        mqttClient = MQTT.newConnection(mqttConfig)
        NSLog("MQTT connecting")
    }
    
    func disconnect() {
        NSLog("MQTT disconnecting")
        mqttClient?.disconnect()
    }
    
    deinit {
        disconnect()
    }
}

// MARK: HTTP proxied client

class HttpClient: NSObject, Client {
    var apiURL: String?
    
    func publish(topic: String, message: String) {
        NSLog("httpclient publish")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message
        ])
    }
    
    func publish(topic: String, message: String, completion: ((ClientStatus) -> ())) {
        NSLog("httpclient publish with callback")
        
        Alamofire.request(.POST, apiURL!, parameters: [
            "topic": topic,
            "message": message
        ]).responseJSON { response in
            if response.result.isSuccess {
                completion(ClientStatus.Success)
            } else {
                completion(ClientStatus.Failure)
            }
        }
    }
    
    func connect(options: NSDictionary) {
        // We cannot access the preferences yet in init()
        apiURL = prefString("api_mqtt_url")
        // No connection necessary
        NSLog("HTTP connecting")
    }
    
    func disconnect() {
        // No disconnection necessary
        NSLog("HTTP disconnecting")
    }
}