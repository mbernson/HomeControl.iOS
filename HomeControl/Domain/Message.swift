//
//  Message.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

struct Message {
  let topic: String
  let payload: String?
  let qos: Int
  let retain: Bool

  func isTruthy() -> Bool {
    guard let payload = payload else { return false }
    switch payload {
    case "on", "yes", "1", "true":
      return true
    case "off", "no", "0", "false":
      return false
    default: return false
    }
  }
}