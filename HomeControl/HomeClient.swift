//
//  HomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation
import Promissum
import RxSwift

typealias Topic = String

protocol HomeClient {
  func publish(message: Message) -> Promise<HomeClientStatus, ErrorType>

  func subscribe(topic: Topic) -> Observable<Message>
//  func unsubscribe(topic: Topic)

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

struct HomeClientError: ErrorType, CustomStringConvertible {
  let message: String
  var description: String {
    return message
  }
}