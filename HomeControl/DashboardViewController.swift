//
//  DashboardViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/01/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import Rswift

class DashBoardViewController: UICollectionViewController {

  var actions = [
    MessageAction(topic: "hildebrandpad/lights/all", payload: "on", type: .ToggleSwitch, description: "Alle lichten"),
    MessageAction(topic: "hildebrandpad/lights/all", payload: "on", type: .ToggleSwitch, description: "Bureaulamp"),
    MessageAction(topic: "test", payload: "test", type: .PushButton, description: "Send test"),
//    MessageAction(topic: "hildebrandpad/temperature", payload: nil, type: .Gauge, description: "Temperatuur"),
  ]

  let reuseMap: [ActionType : String] = [
    .PushButton: R.reuseIdentifier.pushButtonCollectionViewCell.identifier,
    .ToggleSwitch: R.reuseIdentifier.toggleSwitchCollectionViewCell.identifier,
  ]

  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.delegate = self
    collectionView?.dataSource = self

    collectionView?.registerNib(R.nib.toggleSwitchCollectionViewCell)
    collectionView?.registerNib(R.nib.buttonCollectionViewCell)
  }

  // MARK: Collection view data source

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return actions.count
  }

  // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let action = actions[indexPath.row]
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMap[action.type]!, forIndexPath: indexPath) as! DashboardCollectionViewCell

    cell.action = action
    // Customize
    return cell
  }

  // MARK: Collection view delegate

  override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
    //
  }

  override func collectionView(collectionView: UICollectionView, canMoveItemAtIndexPath indexPath: NSIndexPath) -> Bool {
    return true
  }
}

struct DashboardViewModel {
  //  let cells: [Cell]
}