//
//  UIColor+Hex.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

extension UIColor {

  convenience init(hex: Int) {
    self.init(red: CGFloat((hex & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((hex & 0xFF00) >> 8) / 255.0,
              blue: CGFloat(hex & 0xFF) / 255.0,
              alpha: 1)
  }

}