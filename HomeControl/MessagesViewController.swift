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
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!

    var messageChoices = ["", "on", "off", "yes", "no"]
    let default_message_choice = "on"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.client = sharedClient()
        
        let messagePickerView = UIPickerView()
        messagePickerView.delegate = self
        messageTextField.inputView = messagePickerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        if(client == nil) {
            NSLog("MQTT client is nil!")
        }
        self.messageTextField.resignFirstResponder()
        client?.publish(getTopic(), message: getMessage())
    }
    
    @IBAction func viewWasTapped(sender: AnyObject) {
        self.messageTextField.resignFirstResponder()
    }
    
    func getMessage() -> String {
        if(messageTextField.hasText()) {
            return messageTextField.text!
        } else {
            return default_message_choice
        }
    }

    func getTopic() -> String {
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