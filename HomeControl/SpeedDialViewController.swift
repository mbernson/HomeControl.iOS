//
//  SpeedDialViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Moscapsule

class SpeedDialViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    let columns: CGFloat = 2
    let horizontalMargin: CGFloat = 10.0 // TODO: Replace hard-coded value with the minimum spacing property of the collection view
    private let reuseIdentifier = "SpeedDialCell"
    
    // TODO: Replace hard-coded actions
    private var actions: [ButtonAction] = [
        ButtonAction(topic: "hildebrandpad/livingroom/lights/all", message: "on", description: "Alle lichten aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/all", message: "off", description: "Alle lichten uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", message: "on", description: "Staande lamp aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", message: "off", description: "Staande lamp uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", message: "on", description: "Bureaulamp aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", message: "off", description: "Bureaulamp uit"),
        
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", message: "on", description: "Bed lampen aan"),
        ButtonAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", message: "off", description: "Bed lampen uit"),
    ]
    
    var client: Client?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.client = sharedClient()
    }
    
    // Gets called from the SpeedDialCollectionViewCell
    func performButtonAction(action: ButtonAction, completion: ((ClientStatus) -> ())) {
        client?.publish(action.topic, message: action.message, completion: completion)
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
        cell.viewController = self
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
    var viewController: SpeedDialViewController?
    
    @IBOutlet weak var button: UIButton!
    
    @IBAction func buttonTouchedUp(sender: AnyObject) {
        assert(viewController != nil, "SpeedDialCollectionViewCell viewController has not been set")
        self.animateSuccess()
        viewController?.performButtonAction(action, completion: self.actionWasSent)
    }
    
    func actionWasSent(result: ClientStatus) {
        if result == .Success {
            animateEnd()
        } else {
            animateFailure()
            showErrorMessage()
        }
    }
    
    func showErrorMessage() {
        let alert = UIAlertController(title: "Connection error", message:"The IoT service is unavailable or responded with an error.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok :(", style: .Default) { _ in })
        viewController?.presentViewController(alert, animated: true){}
    }
    
    func animateSuccess() {
        UIView.animateWithDuration(0.25, animations: {
            self.backgroundColor = UIColor.greenColor()
        }, completion: { success in
            
        })
    }
    
    func animateFailure() {
        UIView.animateWithDuration(1, animations: {
            self.backgroundColor = UIColor.blackColor()
        }, completion: { success in
            self.animateEnd()
        })
    }
    
    func animateEnd() {
        UIView.animateWithDuration(0.25, animations: {
            self.backgroundColor = self.window?.tintColor
        })
    }
}