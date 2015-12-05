//
//  SpeedDialViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule


struct ButtonAction {
    let topic: String
    let message: String
    let description: String
}


class SpeedDialViewController: UICollectionViewController {
    private let reuseIdentifier = "SpeedDialCell"
    private let sectionInsets = UIEdgeInsets(top: 40.0, left: 20.0, bottom: 60.0, right: 20.0)
    
    private var actions = [
        ButtonAction(topic: "hildebrandpad/livingroom/lights/all", message: "on", description: "Alle lichten aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/all", message: "off", description: "Alle lichten uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", message: "on", description: "Staande lamp aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", message: "off", description: "Staande lamp uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", message: "on", description: "Bureaulamp aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", message: "off", description: "Bureaulamp uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", message: "on", description: "Bed lampen aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", message: "off", description: "Bed lampen uit"),
    ]
    
    var client: MQTTClient?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.client = sharedMQTTClient()
    }
    
    func performAction(action: ButtonAction) {
        client?.publishString(action.message, topic: action.topic, qos: 2, retain: false)
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpeedDialCollectionViewCell
        
        cell.action = actions[indexPath.row]
        cell.button.setTitle(cell.action.description, forState: .Normal)
        cell.delegate = self
        cell.layer.cornerRadius = 30
        cell.backgroundColor = collectionView.window?.tintColor
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        insetForSectionAtIndex section: Int) -> UIEdgeInsets {
            return sectionInsets
    }
}

class SpeedDialCollectionViewCell: UICollectionViewCell {
    var action: ButtonAction!
    var delegate: SpeedDialViewController?
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTouchedUp(sender: AnyObject) {
        delegate?.performAction(action)
        animate()
    }
    
    func animate() {
        UIView.beginAnimations("speeddialbutton", context: nil)
        UIView.setAnimationDuration(0.4)
        self.backgroundColor = UIColor.greenColor()
        UIView.commitAnimations()
        
        UIView.beginAnimations("speeddialbutton_revert", context: nil)
        UIView.setAnimationDuration(0.4)
        self.backgroundColor = self.window?.tintColor
        UIView.commitAnimations()
    }
}