//
//  MessagePubSub.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

protocol SendsMessages {
  var action: MessageAction? { get }

  func send(message: Message)
  func send(message: Message, completion: HomeClientStatus -> Void)
}

protocol SubscribesToMessages {
  func subscribe(client: HomeClient)
  func unsubscribe(client: HomeClient)
}