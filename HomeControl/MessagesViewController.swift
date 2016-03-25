//
//  MessagesViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule


class MessagesViewController : UIViewController {

  var client: HomeClient?

  var messageChoices = ["on", "off", "yes", "no"]
  let defaultMessageChoice = "on"

  var enterCustomMessage: Bool = true

  // MARK: Initializers

  override func viewDidLoad() {
    super.viewDidLoad()
    self.client = App.homeClient
  }

  // MARK: Outlets and actions

  @IBOutlet weak var topicTextField: UITextField!
  @IBOutlet weak var messageTextField: UITextField!

  @IBAction func sendButtonPressed(sender: AnyObject) {
    self.messageTextField.resignFirstResponder()
    guard let client = client, topic = topicTextField.text else { return }
    let message = Message(topic: topic, payload: messageTextField.text ?? defaultMessageChoice, qos: 2, retain: false)
    client.publish(message) { result in
      print("message was sent")
    }
  }

  @IBAction func viewWasTapped(sender: AnyObject) {
    self.messageTextField.resignFirstResponder()
  }

  @IBAction func customMessageSwitchChanged(sender: UISwitch) {
    self.messageTextField.resignFirstResponder()
    if(!sender.on) {
      let messagePickerView = UIPickerView()
      messagePickerView.delegate = self
      messageTextField.inputView = messagePickerView
    } else {
      messageTextField.inputView = nil
    }
    self.messageTextField.becomeFirstResponder()
  }
}

extension MessagesViewController: UIPickerViewDataSource, UIPickerViewDelegate {
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return messageChoices.count
  }

  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return messageChoices[row]
  }

  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    messageTextField.text = messageChoices[row]
  }
}