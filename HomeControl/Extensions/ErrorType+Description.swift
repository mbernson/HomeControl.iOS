//
//  ErrorType+Description.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

extension Error {

  var description: String {
    get {
      if let error = self as? CustomStringConvertible {
        return error.description
      }

      if let description = (self as NSError).userInfo[NSLocalizedDescriptionKey] as? String {
        return description
      }

      return NSLocalizedString("Unknown error", comment: "")
    }
  }
  
}
