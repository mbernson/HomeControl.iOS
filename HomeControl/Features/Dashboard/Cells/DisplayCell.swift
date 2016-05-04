//
//  DisplayCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 20/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

class DisplayCell: UICollectionViewCell, ReceivesMessages {
  deinit {
    print("DisplayCell deinit")
  }

  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var outputLabel: UILabel!

  func subscribeForChanges(action: MessageAction, client: HomeClient, disposeBag: DisposeBag) {
    titleLabel.text = action.description
    outputLabel.text = "No value received"
    client.subscribe(action.message.topic).subscribeNext { [weak self] message in
      self?.outputLabel.text = message.payloadString
    }.addDisposableTo(disposeBag)
  }

}