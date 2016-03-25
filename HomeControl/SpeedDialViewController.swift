//
//  SpeedDialViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 05/12/15.
//  Copyright © 2015 Duckson. All rights reserved.
//

import UIKit
import Rswift
import Moscapsule

let actions = [
  MessageAction(topic: "hildebrandpad/lights/all", payload: "on", type: .PushButton, description: "Alle lichten aan"),
  MessageAction(topic: "hildebrandpad/livingroom/lights/all", payload: "off", type: .PushButton, description: "Alle lichten uit"),

  MessageAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", payload: "on", type: .PushButton, description: "Staande lamp aan"),
  MessageAction(topic: "hildebrandpad/livingroom/lights/staande_lamp", payload: "off", type: .PushButton, description: "Staande lamp uit"),

  MessageAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", payload: "on", type: .PushButton, description: "Bureaulamp aan"),
  MessageAction(topic: "hildebrandpad/livingroom/lights/bureaulamp", payload: "off", type: .PushButton, description: "Bureaulamp uit"),

  MessageAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", payload: "on", type: .PushButton, description: "Bed lampen aan"),
  MessageAction(topic: "hildebrandpad/livingroom/lights/bed_lampen", payload: "off", type: .PushButton, description: "Bed lampen uit"),

  MessageAction(topic: "test", payload: "on", type: .PushButton, description: "Test aan"),
  MessageAction(topic: "test", payload: "off", type: .PushButton, description: "Test uit"),
]

class SpeedDialViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

  let columns: CGFloat = 2

  // TODO: Replace hard-coded value with the minimum spacing property of the collection view
  let horizontalMargin: CGFloat = 10.0

  var client: HomeClient

  required init?(coder aDecoder: NSCoder) {
    client = SwitchingHomeClient()

    super.init(coder: aDecoder)
  }

  // Gets called from the SpeedDialCollectionViewCell
  func performButtonAction(action: MessageAction, completion: HomeClientStatus -> Void) {
    client.publish(action.message, completion: completion)
  }

  // Delegate methods
  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return actions.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(R.reuseIdentifier.pushButtonCollectionViewCell, forIndexPath: indexPath)!

    // Cell customization
    cell.action = actions[indexPath.row]
    cell.button.setTitle(description, forState: .Normal)
    //        cell.viewController = self
    cell.layer.cornerRadius = 30
    cell.backgroundColor = collectionView.window?.tintColor

    return cell
  }

  func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    let cellWidth = (self.view.bounds.width / columns) - (horizontalMargin * columns) - horizontalMargin
    return CGSize(width: cellWidth, height: cellWidth)
  }
}

class SpeedDialCollectionViewCell: UICollectionViewCell {
  var action: MessageAction!
  //    {
  //        get { }
  //        set {
  //            self.actionWasSet(s)
  //        }
  //    }
  var viewController: SpeedDialViewController?

  func actionWasSent(result: HomeClientStatus) {
    if result == .Success {
      animateEnd()
    } else {
      animateFailure()
      showAlert("Connection error", message: "The IoT service is unavailable or responded with an error.")
    }
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

  func showAlert(title: String, message: String) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    alert.addAction(UIAlertAction(title: "Ok :(", style: .Default) { _ in })
    viewController?.presentViewController(alert, animated: true) { }
  }
}

class SpeedDialToggleSwitchCell: SpeedDialCollectionViewCell {

  @IBOutlet weak var toggleSwitch: UISwitch!

  private static let onValue = "on", offValue = "off"

  @IBAction func toggle(sender: UISwitch) {
    print("toggled")
    if toggleSwitch.on {
      //            action.message = onValue
    } else {
      //            action.message = offValue
    }
    self.animateSuccess()
    viewController?.performButtonAction(action, completion: self.actionWasSent)
  }
}

class SpeedDialPushButtonCell: SpeedDialCollectionViewCell {
  @IBOutlet weak var button: UIButton!

  @IBAction func buttonTouchedUp(sender: AnyObject) {
    assert(viewController != nil, "SpeedDialCollectionViewCell viewController has not been set")
    self.animateSuccess()
    viewController?.performButtonAction(action, completion: self.actionWasSent)
  }
}