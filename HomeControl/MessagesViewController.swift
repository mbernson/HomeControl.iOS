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
    
    var client: Client?
    
    var messageChoices = ["on", "off", "yes", "no"]
    let default_message_choice = "on"
    
    var enterCustomMessage: Bool = true
    
    // MARK: Initializers
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = sharedClient()
    }
    
    // MARK: Outlets and actions
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        self.messageTextField.resignFirstResponder()
        assert(client != nil, "No client to send the message to")
        client?.publish(topic(), message: message())
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
    
    // MARK: Getting data from the view
    
    func message() -> String {
        if(messageTextField.hasText()) {
            return messageTextField.text!
        } else {
            return default_message_choice
        }
    }

    func topic() -> String {
        return topicTextField.text!
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