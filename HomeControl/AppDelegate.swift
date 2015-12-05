//
//  AppDelegate.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule

func prefString(key: String) -> String {
    return NSUserDefaults.standardUserDefaults().stringForKey(key)!
}
func prefInt(key: String) -> Int {
    return NSUserDefaults.standardUserDefaults().integerForKey(key)
}

func appDelegate() -> AppDelegate {
    let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
    return delegate
}

func sharedMQTTClient() -> MQTTClient {
    return appDelegate().mqttClient!
}

func createMQTTClient() -> MQTTClient {
    // set MQTT Client Configuration
    
    let mqttConfig = MQTTConfig(clientId: prefString("mqtt_client_id"), host: prefString("mqtt_host"), port: Int32(prefInt("mqtt_port")), keepAlive: 60)
    mqttConfig.onPublishCallback = { messageId in
        NSLog("published (mid=\(messageId))")
    }
    mqttConfig.onMessageCallback = { mqttMessage in
        NSLog("MQTT Message received: payload=\(mqttMessage.payloadString)")
    }
    
    // create new MQTT Connection
    return MQTT.newConnection(mqttConfig)
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var mqttClient: MQTTClient?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        let appDefaults = [
            "mqtt_client_id": "homecontrol-app",
            "mqtt_host": "homepi",
            "mqtt_port": 1883
        ]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(appDefaults)
        
        self.mqttClient = createMQTTClient()
        
        let themeColor = UIColor(red: 251/255, green: 70/255, blue: 45/255, alpha: 1)
        window?.tintColor = themeColor
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.

        self.mqttClient!.disconnect()
    }


}

