//
//  Utility.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 30/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit

// Convenience functions

func userDefaults() -> NSUserDefaults {
    return NSUserDefaults.standardUserDefaults()
}

func appDelegate() -> AppDelegate {
    return UIApplication.sharedApplication().delegate as! AppDelegate
}

func sharedClient() -> Client {
    return appDelegate().client
}