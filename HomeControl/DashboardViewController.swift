//
//  DashboardViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/01/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import Rswift
import RxSwift

class DashBoardViewController: UICollectionViewController {

  var widgets: [MessageAction] = [
    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "foo display", type: .Display),
    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar display", type: .Display),
    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo on", type: .PushButton),
    MessageAction(message: Message(topic: "foo", payloadString: "off"), description: "Foo off", type: .PushButton),

    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar toggle", type: .ToggleSwitch),
    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo toggle", type: .ToggleSwitch),
  ]

  let reuseMap: [ActionType : String] = [
    .PushButton: R.reuseIdentifier.pushButtonCollectionViewCell.identifier,
    .ToggleSwitch: R.reuseIdentifier.toggleSwitchCollectionViewCell.identifier,
    .Display: R.reuseIdentifier.displayCell.identifier,
  ]

  let client: HomeClient = MqttHomeClient()
  let disposeBag = DisposeBag()

  override func viewDidLoad() {
    super.viewDidLoad()

    client.connect().dispatchMain().then {
      print("dashboard connected")
    }.trap { [weak self] error in
      print("dashboard connection error")
      print(error)
      self?.presentError(error)
    }

    collectionView?.delegate = self
    collectionView?.dataSource = self

    collectionView?.registerNib(R.nib.toggleSwitchCollectionViewCell)
    collectionView?.registerNib(R.nib.buttonCollectionViewCell)
    collectionView?.registerNib(R.nib.displayCell)
  }

  // MARK: Collection view data source

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return widgets.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let widget = widgets[indexPath.row]
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMap[widget.type]!, forIndexPath: indexPath)

    cell.layer.cornerRadius = 30
    cell.backgroundColor = collectionView.window?.tintColor

    if var sendingCell = cell as? SendsMessages {
      sendingCell.homeClient = client
      sendingCell.action = widget
    }
    
    if let receivingCell = cell as? ReceivesMessages {
      receivingCell.subscribeForChanges(client)
    }

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