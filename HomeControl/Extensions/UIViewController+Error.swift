//
//  UIViewController+Error.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/04/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

extension UIViewController {

  func presentError(_ error: Error, title: String? = nil) {
    let alertController = UIAlertController(
      title: title,
      message: error.description,
      preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "[TEMP]"), style: .default, handler: nil))

    present(alertController, animated: true, completion: nil)
  }

  func presentMessage(_ message: String, title: String? = nil) {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert)

    alertController.addAction(UIAlertAction(title: NSLocalizedString("Ok", comment: "[TEMP]"), style: .default, handler: nil))

    present(alertController, animated: true, completion: nil)
  }

}
