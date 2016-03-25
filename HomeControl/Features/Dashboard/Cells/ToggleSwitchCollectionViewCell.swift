//
//  ToggleSwitchCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ToggleSwitchCollectionViewCell: DashboardCollectionViewCell {

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var toggleSwitch: UISwitch!

  @IBAction func switchValueDidChange(sender: AnyObject) {
    guard let action = action else { return }
    send()
  }

  func didReceiveMessage(message: Message) {
    print("ToggleSwitchCollectionViewCell didReceiveMessage")
    toggleSwitch.setOn(message.isTruthy(), animated: true)
  }
}
