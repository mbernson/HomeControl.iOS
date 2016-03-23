//
//  Repository.swift
//  DataMapper
//
//  Created by Mathijs Bernson on 17/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

public enum Result {
  case Saved
  case Error
}

public protocol Repository {
  func persist<T>(model: T) -> Result
}