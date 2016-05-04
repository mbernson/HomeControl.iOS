//
//  ConnectionIndicatorView.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 26/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class ConnectionIndicatorView: UIView {

  override init(frame: CGRect) {
    super.init(frame: frame)
    initialize()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    initialize()
  }

  func initialize() {

    let view = UINib(nibName: "ConnecdtionIndicatorView", bundle: nil)
    let v = view.instantiateWithOwner(self, options: nil).first as! UIView
      addSubview(v)
//      view.autoPinEdgesToSuperviewEdges()
//    }
  }
}
