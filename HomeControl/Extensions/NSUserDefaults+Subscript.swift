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
extension NSUserDefaults {
  subscript(key: Key<String>) -> String? {
    get {
      return stringForKey(key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<Int>) -> Int? {
    get {
      return integerForKey(key.name)
    }
    set {
      if let value = newValue {
        setInteger(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<Double>) -> Double? {
    get {
      return doubleForKey(key.name)
    }
    set {
      if let value = newValue {
        setDouble(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<Bool>) -> Bool? {
    get {
      return boolForKey(key.name)
    }
    set {
      if let value = newValue {
        setBool(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<NSData>) -> NSData? {
    get {
      return dataForKey(key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<NSDate>) -> NSDate? {
    get {
      return objectForKey(key.name) as? NSDate
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<[String : Bool]>) -> [String : Bool]? {
    get {
      return objectForKey(key.name) as? [String : Bool]
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }

  subscript(key: Key<[String]>) -> [String]? {
    get {
      return stringArrayForKey(key.name)
    }
    set {
      if let value = newValue {
        setValue(value, forKey: key.name)
      }
      else {
        removeObjectForKey(key.name)
      }
    }
  }
}