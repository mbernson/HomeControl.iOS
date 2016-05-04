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
    titleLabel.text = "Value of \(action.message.topic)"
    outputLabel.text = "No value available"
    client.subscribe(action.message.topic).subscribeNext { [weak self] message in
      self?.outputLabel.text = message.payloadString
    }.addDisposableTo(disposeBag)
  }

}