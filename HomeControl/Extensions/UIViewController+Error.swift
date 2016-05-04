//
//  UIViewController+Error.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentError(error: ErrorType, title: String? = nil) {
    let alertController = UIAlertController(
      title: title,
      message: error.description,
      preferredStyle: .Alert)

    alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "[TEMP]"), style: .Default, handler: nil))

    presentViewController(alertController, animated: true, completion: nil)
  }

  func presentMessage(message: String, title: String? = nil) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .Alert)

    alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "[TEMP]"), style: .Default, handler: nil))

    presentViewController(alertController, animated: true, completion: nil)
  }

}