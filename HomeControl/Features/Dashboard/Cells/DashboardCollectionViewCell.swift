//
//  DashboardCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
  var action: MessageAction?
  var client: HomeClient?

  func sen
}

class MessageSenderCell: DashboardCollectionViewCell {

}

class MessageSubscriberCell: DashboardCollectionViewCell {
  func subscribe(client: HomeClient) {
    //    guard let message = action?.message else { return }
    //    client.subscribe(message.topic, listener: self)
  }

  func unsubscribe(client: HomeClient) {
    //    guard let message = action?.message else { return }
    //    client.unsubscribe(message.topic)
  }

  func didReceiveMessage(message: Message) {
    //
  }
}