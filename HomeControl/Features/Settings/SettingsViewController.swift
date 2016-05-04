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
      textFields[index].text = userDefaults.stringForKey(tag)
    }
    testConnectionSpinner.hidden = true
  }

  let userDefaults = NSUserDefaults.standardUserDefaults()

  let tags = [
    0: "mqtt_host",
    1: "mqtt_port",
    2: "api_mqtt_url",
  ]

  private func savePreference(forTextField textField: UITextField) {
    let index = textFields.indexOf(textField)!
    let tag = tags[index]!
    userDefaults.setValue(textField.text, forKey: tag)
  }

  func textFieldDidEndEditing(textField: UITextField) {
    if textField.hasText() {
      savePreference(forTextField: textField)
    }
  }

  func textFieldShouldReturn(textField: UITextField) -> Bool {
    if textField.hasText() {
      savePreference(forTextField: textField)
      textField.resignFirstResponder()
      return true
    }
    return false
  }

  @IBAction func testConnection(sender: AnyObject) {
    testConnectionSpinner.hidden = false

    let client = MqttHomeClient(userDefaults: userDefaults)
    client.connect().then { [weak self] in
        self?.presentMessage("Connection successful")
      }.trap { [weak self] error in
        self?.presentError(error)
      }.finally { [weak self] in
        client.disconnect()
        self?.testConnectionSpinner.hidden = true
      }
  }

}