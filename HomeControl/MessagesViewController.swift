//
//  MessagesViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule


class MessagesViewController : UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var client: MQTTClient?
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!

    var messageChoices = ["on", "off", "yes", "no"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.client = delegate.mqttClient
        
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
        client?.publishString(getMessage(), topic: getTopic(), qos: 2, retain: false, requestCompletion: { result in
        })
    }
    
    func getMessage() -> String {
        if(messageTextField.hasText()) {
            return messageTextField.text!
        } else {
            return "on"
        }
    }

    func getTopic() -> String {
        return topicTextField.text!
    }
    
    // UIPicker Delegate
    
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
