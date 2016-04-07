//
//  ButtonCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: DashboardCollectionViewCell {

  @IBOutlet weak var button: UIButton!

  @IBAction func buttonTouchedUp(sender: AnyObject) {
//    assert(viewController != nil, "SpeedDialCollectionViewCell viewController has not been set")
//    self.animateSuccess()
//    viewController?.performButtonAction(action, completion: self.actionWasSent)
    print("buttonTouchedUp")
    guard let message = action?.nextMessage() else { return }
    client?.publish(message)
  }

  override func layoutCell() {
    button.setTitle(action?.description, forState: .Normal)
  }

}
