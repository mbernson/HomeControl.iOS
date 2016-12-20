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

  @IBAction func switchValueDidChange(_ sender: AnyObject) {
    guard var action = action else { return }
    guard let oldValue = action.message.asBoolean() else { return }

    let newValue = oldValue ? "off" : "on"
    // Copy the message but
    action.message = Message(topic: action.message.topic, payloadString: newValue, qos: action.message.qos, retain: action.message.retain)
    self.action = action

    // TODO: Use this result maybe?
    let _ = sendCurrentMessage()
  }

  func subscribeForChanges(_ action: MessageViewModel, client: HomeClient, disposeBag: DisposeBag) {
    homeClient = client

    client.subscribe(action.message.topic).subscribe { event in
      if let message = event.element {
        if let newState = message.asBoolean() {
          self.toggleSwitch.setOn(newState, animated: true)
        }
        self.action?.message = message
      }
    }.addDisposableTo(disposeBag)
  }
}
