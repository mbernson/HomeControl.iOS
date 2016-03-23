//
//  MessagePubSub.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

protocol SendsMessages {
  func send(client: HomeClient)
  func send(client: HomeClient, completion: HomeClientStatus -> Void)
}

protocol SubscribesToMessages {
  func subscribe(client: HomeClient)
  func unsubscribe(client: HomeClient)
}