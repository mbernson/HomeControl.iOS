//
//  Models.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation


struct MessageAction {
    let topic: String
    let message: String
    let description: String
    
    func send(client: HomeClient) {
        client.publish(self.topic, message: self.message, retain: true)
    }
    
    func send(client: HomeClient, completion: HomeClientStatus -> Void) {
        client.publish(self.topic, message: self.message, retain: true, completion: completion)
    }
}
