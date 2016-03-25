//
//  ButtonCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: DashboardCollectionViewCell, MessageSenderCell {

  @IBOutlet weak var button: UIButton!

  var action: MessageAction? { get set }

  @IBAction func buttonTouchedUp(sender: AnyObject) {
//    assert(viewController != nil, "SpeedDialCollectionViewCell viewController has not been set")
//    self.animateSuccess()
//    viewController?.performButtonAction(action, completion: self.actionWasSent)
  }
  

}
