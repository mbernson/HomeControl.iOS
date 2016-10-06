//
//  SettingsViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate {

  @IBOutlet var textFields: [UITextField]!
  @IBOutlet weak var testConnectionSpinner: UIActivityIndicatorView!

  override func viewDidLoad() {
    super.viewDidLoad()
    for (index, tag) in tags {
      textFields[index].text = userDefaults.string(forKey: tag)
    }
    testConnectionSpinner.isHidden = true
  }

  let userDefaults = Foundation.UserDefaults.standard

  let tags = [
    0: "mqtt_host",
    1: "mqtt_port",
    2: "api_mqtt_url",
  ]

  fileprivate func savePreference(forTextField textField: UITextField) {
    let index = textFields.index(of: textField)!
    let tag = tags[index]!
    userDefaults.setValue(textField.text, forKey: tag)
  }

  func textFieldDidEndEditing(_ textField: UITextField) {
    if textField.hasText {
      savePreference(forTextField: textField)
    }
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if textField.hasText {
      savePreference(forTextField: textField)
      textField.resignFirstResponder()
      return true
    }
    return false
  }

  @IBAction func testConnection(_ sender: AnyObject) {
    testConnectionSpinner.isHidden = false

    let client = MqttHomeClient(userDefaults: userDefaults)
    client.connect().then { [weak self] in
        self?.presentMessage("Connection successful")
      }.trap { [weak self] error in
        self?.presentError(error)
      }.finally { [weak self] in
        client.disconnect()
        self?.testConnectionSpinner.isHidden = true
      }
  }

}
