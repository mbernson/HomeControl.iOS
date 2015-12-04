//
//  MessagesViewControlkler.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 04/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule

class MessagesViewController : UIViewController {
    
    var client: MQTTClient?
    
    @IBOutlet weak var topicTextField: UITextField!
    @IBOutlet weak var messageTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let delegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.client = delegate.mqttClient
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendButtonPressed(sender: AnyObject) {
        let topic: String = topicTextField.text!
        let message: String = messageTextField.text!
        
        client?.publishString(message, topic: topic, qos: 2, retain: false, requestCompletion: { result in
        })
    }
    
}
