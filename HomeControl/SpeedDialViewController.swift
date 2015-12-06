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


class SpeedDialViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let columns: CGFloat = 2
    let horizontalMargin: CGFloat = 10.0 // TODO: Replace hard-coded value with the minimum spacing property of the collection view
    private let reuseIdentifier = "SpeedDialCell"
    
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
    
    // Gets called from the SpeedDialCollectionViewCell
    func performAction(action: ButtonAction) {
        client?.publishString(action.message, topic: action.topic, qos: 2, retain: false)
    }

    // Delegate methods
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return actions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SpeedDialCollectionViewCell
        
        // Cell customization
        cell.action = actions[indexPath.row]
        cell.button.setTitle(cell.action.description, forState: .Normal)
        cell.delegate = self
        cell.layer.cornerRadius = 30
        cell.backgroundColor = collectionView.window?.tintColor
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let cellWidth = (self.view.bounds.width / columns) - (horizontalMargin * columns) - horizontalMargin
        let size: CGSize = CGSize(width: cellWidth, height: cellWidth)
        return size
    }
}

class SpeedDialCollectionViewCell: UICollectionViewCell {
    var action: ButtonAction!
    var delegate: SpeedDialViewController?
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTouchedUp(sender: AnyObject) {
        assert(delegate != nil, "SpeedDialCollectionViewCell delegate has not been set")
        delegate?.performAction(action)
        animateButtonPress()
    }
    
    func animateButtonPress() {
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