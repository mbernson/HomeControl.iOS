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
import SystemConfiguration

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

func createClient() -> Client {
    let hostname = prefString("mqtt_host")
    var mqttHostReachable: Bool
    do {
        let reach = try Reachability(hostname: hostname)
        mqttHostReachable = reach.isReachableViaWiFi()
    } catch {
        mqttHostReachable = false
    }
    
    if mqttHostReachable { // Check if the name resolved
        NSLog("Using MQTT client")
        return AMQTTClient()
    } else {
        NSLog("Using HTTP client")
        return HttpClient()
    }
}

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
    }
    
    func disconnect() {
        mqttClient?.disconnect()
    }
}

class HttpClient: NSObject, Client {
    let apiURL: String
    
    override init() {
        apiURL = prefString("api_mqtt_url")
        super.init()
    }
    
    func publish(topic: String, message: String) {
        NSLog("httpclient publish")
        
        Alamofire.request(.POST, apiURL, parameters: [
            "topic": topic,
            "message": message
        ])
    }
    
    func publish(topic: String, message: String, completion: ((ClientStatus) -> ())) {
        NSLog("httpclient publish with callback")
        
        Alamofire.request(.POST, apiURL, parameters: [
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
        // No connection necessary
    }
    
    func disconnect() {
        //
    }
}