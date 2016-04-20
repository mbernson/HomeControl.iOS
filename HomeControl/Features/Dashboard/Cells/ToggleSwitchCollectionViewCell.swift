//
//  ToggleSwitchCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

class ToggleSwitchCollectionViewCell: UICollectionViewCell, SendsMessages, ReceivesMessages {

  var homeClient: HomeClient?
  var action: MessageAction? {
    didSet {
      titleLabel.text = action?.description
    }
  }
  var disposable: Disposable?

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var toggleSwitch: UISwitch!

  @IBAction func switchValueDidChange(sender: AnyObject) {
    guard var action = action else { return }
    guard let oldValue = action.message.asBoolean() else { return }
    let newValue = oldValue ? "off" : "on"
    action.message = Message(topic: action.message.topic, payloadString: newValue, qos: action.message.qos, retain: action.message.retain)
    self.action = action
    sendCurrentMessage().then { _ in
      print("message published!")
    }
  }

  override func prepareForReuse() {
    super.prepareForReuse()
    disposable?.dispose()
  }

  func subscribeForChanges(client: HomeClient) {
    disposable = client.subscribe(action!.message.topic).subscribeNext { [weak self] message in
      if let newState = message.asBoolean() {
        self?.toggleSwitch.setOn(newState, animated: true)
      }
    }
  }
}
