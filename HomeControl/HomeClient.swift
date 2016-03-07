//
//  HomeClient.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 06/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import Foundation
import Moscapsule
import Alamofire
import ReachabilitySwift


// MARK: HomeClient protocol

protocol HomeClient {
    func publish(topic: String, message: String, retain: Bool)
    func publish(topic: String, message: String, retain: Bool, completion: ((HomeClientStatus) -> ()))
    
    func connect()
    func disconnect()
}


enum HomeClientStatus {
    case Success
    case Failure
}