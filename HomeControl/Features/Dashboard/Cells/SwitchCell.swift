//
//  ToggleSwitchCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

class SwitchCell: UICollectionViewCell, SendsMessages, ReceivesMessages {

  deinit {
    print("ToggleSwitchCollectionViewCell deinit")
  }

  var homeClient: HomeClient?
  var action: MessageViewModel? {
    didSet {
      titleLabel.text = action?.description
    }
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var toggleSwitch: UISwitch!

  @IBAction func switchValueDidChange(sender: AnyObject) {
    guard var action = action else { return }
    guard let oldValue = action.message.asBoolean() else { return }

    let newValue = oldValue ? "off" : "on"
    // Copy the message but
    action.message = Message(topic: action.message.topic, payloadString: newValue, qos: action.message.qos, retain: action.message.retain)
    self.action = action

    sendCurrentMessage()
  }

  func subscribeForChanges(action: MessageViewModel, client: HomeClient, disposeBag: DisposeBag) {
    homeClient = client

    client.subscribe(action.message.topic).subscribeNext { message in
      if let newState = message.asBoolean() {
        // Reference to self here
        self.toggleSwitch.setOn(newState, animated: true)
        self.action?.message = message
      }
    }.addDisposableTo(disposeBag)
  }
}
