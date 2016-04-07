//
//  ToggleSwitchCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ToggleSwitchCollectionViewCell: DashboardCollectionViewCell, HomeClientListener {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var toggleSwitch: UISwitch!

  @IBAction func switchValueDidChange(sender: AnyObject) {
    print("switchValueDidChange")
    guard var message = action?.nextMessage() else { return }
    message.payload = String(toggleSwitch.on)
    client?.publish(message)
  }

  override func layoutCell() {
    titleLabel.text = action?.description
    guard let message = action?.nextMessage() else {
      contentView.backgroundColor = UIColor.grayColor()
      return
    }
    if let on = message.asBoolean() {
      toggleSwitch.setOn(on, animated: false)
    }
  }

  func didReceiveMessage(message: Message) {
    print("ToggleSwitchCollectionViewCell didReceiveMessage")
    if let on = message.asBoolean() {
      toggleSwitch.setOn(on, animated: true)
    }
  }
}
