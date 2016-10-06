//
//  NSUserDefaults+Subscript.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//
// https://gist.github.com/tomlokhorst/3d0d3f0b1bb95391b322

// We can use Phantom Types to provide strongly typed acces to NSUserDefaults
// Similar to: http://www.objc.io/blog/2014/12/29/functional-snippet-13-phantom-types/

import Foundation

// A key to UserDefaults has a name and phantom type
struct Key<T> {
  let name: String
}

// Extensions to NSUserDefaults for subscripting using keys.
// Apparently generics don't work with subscript.
// But this code should be in a library somewhere, so who cares about a little repetition.
extension Foundation.UserDefaults {
  subscript(key: Key<String>) -> String? {
    get {
      return string(forKey: key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<Int>) -> Int? {
    get {
      return integer(forKey: key.name)
    }
    set {
      if let value = newValue {
        set(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<Double>) -> Double? {
    get {
      return double(forKey: key.name)
    }
    set {
      if let value = newValue {
        set(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<Bool>) -> Bool? {
    get {
      return bool(forKey: key.name)
    }
    set {
      if let value = newValue {
        set(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<Data>) -> Data? {
    get {
      return data(forKey: key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<Date>) -> Date? {
    get {
      return object(forKey: key.name) as? Date
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<[String : Bool]>) -> [String : Bool]? {
    get {
      return object(forKey: key.name) as? [String : Bool]
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }

  subscript(key: Key<[String]>) -> [String]? {
    get {
      return stringArray(forKey: key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObject(forKey: key.name)
      }
    }
  }
}
