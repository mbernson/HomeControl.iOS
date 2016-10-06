//
//  MessagesViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit


class MessagesViewController: UIViewController {

  var client: HomeClient?

  var messageChoices = ["on", "off", "yes", "no"]
  let defaultMessageChoice = "on"

  var enterCustomMessage: Bool = true

  // MARK: Initializers

  override func viewDidLoad() {
    super.viewDidLoad()
//    self.client = MqttHomeClient()
    self.client = HttpHomeClient()
  }

  // MARK: Outlets and actions

  @IBOutlet weak var topicTextField: UITextField!
  @IBOutlet weak var messageTextField: UITextField!

  @IBAction func sendButtonPressed(_ sender: AnyObject) {
    self.messageTextField.resignFirstResponder()
    guard let client = client, let topic = topicTextField.text else { return }
    let message = Message(topic: topic, payloadString: messageTextField.text ?? defaultMessageChoice)
    client.publish(message).then { result in
      print("message was sent")
    }
  }

  @IBAction func viewWasTapped(_ sender: AnyObject) {
    self.messageTextField.resignFirstResponder()
  }

  @IBAction func customMessageSwitchChanged(_ sender: UISwitch) {
    self.messageTextField.resignFirstResponder()
    if(!sender.isOn) {
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
  func numberOfComponents(in pickerView: UIPickerView) -> Int {
    return 1
  }

  func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    return messageChoices.count
  }

  func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    return messageChoices[row]
  }

  func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    messageTextField.text = messageChoices[row]
  }
}
