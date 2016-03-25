//
//  HomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation
import UIKit

typealias Topic = String

protocol HomeClient {
  func publish(message: Message)
  func publish(message: Message, completion: HomeClientStatus -> Void)

  func subscribe(topic: Topic, listener: HomeClientListener)
  func unsubscribe(topic: Topic)

  func connect()
  func disconnect()
}

protocol HomeClientListener {
  func didReceiveMessage(message: Message)
}

enum HomeClientStatus {
  case Success
  case Failure
}
