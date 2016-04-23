//
//  DashboardCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

class DashboardCell: UICollectionViewCell {
  var disposable: Disposable?

  override func prepareForReuse() {
    super.prepareForReuse()
    disposable?.dispose()
  }
}