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
  func publish(_ message: Message) -> Promise<Message, HomeClientError>

  func subscribe(_ topic: Topic) -> Observable<Message>

  func connect() -> Promise<Void, HomeClientError>
  func disconnect()

  func sharedClient() -> HomeClient
  func setSharedClient(_ client: HomeClient)
}

extension HomeClient {
  func sharedClient() -> HomeClient {
    return AppDelegate.sharedHomeClient
  }

  func setSharedClient(_ client: HomeClient) {
    AppDelegate.sharedHomeClient = client
  }
}

struct HomeClientError: Error, CustomStringConvertible {
  let message: String
  var description: String {
    return message
  }
}
