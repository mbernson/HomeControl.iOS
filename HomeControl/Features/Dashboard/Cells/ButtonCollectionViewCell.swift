//
//  ButtonCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ButtonCollectionViewCell: UICollectionViewCell, SendsMessages {

  var homeClient: HomeClient?
  var action: MessageAction? {
    didSet {
      button.titleLabel?.text = action?.description
    }
  }

  @IBOutlet weak var button: UIButton!

  @IBAction func buttonTouchedUp(sender: AnyObject) {
    sendCurrentMessage()
  }
}
