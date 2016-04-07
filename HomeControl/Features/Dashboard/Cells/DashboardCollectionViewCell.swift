//
//  DashboardCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class DashboardCollectionViewCell: UICollectionViewCell {
  var action: MessageAction? {
    didSet {
      layoutCell()
    }
  }
  var client: HomeClient?

  func layoutCell() {
    //
  }

}