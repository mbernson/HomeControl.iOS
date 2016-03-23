//
//  SqliteRepository.swift
//  DataMapper
//
//  Created by Mathijs Bernson on 17/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import Foundation

public class SqliteRepository: Repository {
  public init() {
    
  }

  public func persist<T>(model: T) -> Result {
    return .Saved
  }
}