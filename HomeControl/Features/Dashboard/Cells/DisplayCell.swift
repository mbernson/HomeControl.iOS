//
//  DisplayCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 20/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

class DisplayCell: DashboardCell, ReceivesMessages {
  deinit {
    print("DisplayCell deinit")
  }
  @IBOutlet weak var outputLabel: UILabel!

  func subscribeForChanges(client: HomeClient) {
    outputLabel.text = "Geen waarde"
    disposable = client.subscribe("foo/bar").subscribeNext { [weak self] message in
      self?.outputLabel.text = message.payloadString
    }
  }

}