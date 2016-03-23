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
  let payload: String
  let qos: Int
  let retain: Bool
}