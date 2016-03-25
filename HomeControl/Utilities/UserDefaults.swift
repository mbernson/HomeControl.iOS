//
//  UserDefaults.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 24/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

protocol UserDefaults {
  func stringForKey(defaultName: String) -> String?
  func integerForKey(defaultName: String) -> Int
  func boolForKey(defaultName: String) -> Bool
  func URLForKey(defaultName: String) -> NSURL?
}

extension NSUserDefaults: UserDefaults { }