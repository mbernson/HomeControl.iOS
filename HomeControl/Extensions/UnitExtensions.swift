//
//  UnitExtensions.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

extension Int {
  var megaByte: Int {
    return self * Int(pow(10.0, 6.0))
  }
}

extension NSTimeInterval {
  var minutes: NSTimeInterval {
    return self * 60
  }

  var hours: NSTimeInterval {
    return self * 60 * 60
  }
}
