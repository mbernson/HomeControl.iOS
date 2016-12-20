//
//  AppDelegate.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Foundation

let defaultPreferences = [
  "api_mqtt_url": "https://lab.duckson.nl/iot/api/mqtt",
  "mqtt_client_id": "homecontrol-app",
  "mqtt_host": "mathbook-pro.local",
  "mqtt_port": 1883
] as [String : Any]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  static var sharedHomeClient: HomeClient!

  var window: UIWindow?

  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

    Foundation.UserDefaults.standard.register(defaults: defaultPreferences)

    // Customize tint color
    window?.tintColor = Colors.tintColor

    AppDelegate.sharedHomeClient = MqttHomeClient()

    AppDelegate.sharedHomeClient.connect().then {
      print("client connected")
    }.trap { error in
      print("client could not connect")
    }

    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.

  }

  func applicationDidEnterBackground(_ application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    AppDelegate.sharedHomeClient.connect().then {
      print("client connected")
    }.trap { error in
      print("client could not connect")
    }
  }

  func applicationWillTerminate(_ application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
}

