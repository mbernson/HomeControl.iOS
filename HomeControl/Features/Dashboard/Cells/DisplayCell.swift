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

  @IBOutlet weak var outputLabel: UILabel!

  var disposable: Disposable?

  override func prepareForReuse() {
    super.prepareForReuse()
//    disposable?.dispose()
  }

  func subscribeForChanges(client: HomeClient) {
    disposable = client.subscribe("foo/bar").subscribeNext { [weak self] message in
      self?.outputLabel.text = message.payloadString
    }
  }

}