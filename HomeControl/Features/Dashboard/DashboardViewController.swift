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
import RxCocoa

class DashBoardViewController: UICollectionViewController {

  var actions: [MessageAction] = [

    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo on", type: .PushButton),
    MessageAction(message: Message(topic: "foo", payloadString: "off"), description: "Foo off", type: .PushButton),

    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo toggle", type: .ToggleSwitch),
    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo toggle", type: .ToggleSwitch),

    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar on", type: .PushButton),
    MessageAction(message: Message(topic: "bar", payloadString: "off"), description: "Bar off", type: .PushButton),

    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar toggle", type: .ToggleSwitch),
    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar toggle", type: .ToggleSwitch),

    MessageAction(message: Message(topic: "foo", payloadString: "on"), description: "Foo display", type: .Display),
    MessageAction(message: Message(topic: "bar", payloadString: "on"), description: "Bar display", type: .Display),

  ]

  let reuseMap: [ActionType : String] = [
    .PushButton: R.reuseIdentifier.buttonCell.identifier,
    .ToggleSwitch: R.reuseIdentifier.switchCell.identifier,
    .Display: R.reuseIdentifier.displayCell.identifier,
  ]

  var client: HomeClient!
  var disposeBag: DisposeBag! {
    didSet {
      print("disposebag was set!")
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    client = MqttHomeClient(userDefaults: NSUserDefaults.standardUserDefaults())
    disposeBag = DisposeBag()

    client.connect().then {
      print("dashboard connected")
    }.trap { [weak self] error in
      print("dashboard connection error")
      print(error)
      self?.presentError(error)
    }

    collectionView?.delegate = self
    collectionView?.dataSource = self

    collectionView?.registerNib(R.nib.switchCell)
    collectionView?.registerNib(R.nib.buttonCell)
    collectionView?.registerNib(R.nib.displayCell)

    collectionView?.contentInset = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
  }

  // MARK: Collection view data source

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return actions.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let action = actions[indexPath.row]
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMap[action.type]!, forIndexPath: indexPath)

    cell.layer.cornerRadius = 30
    cell.backgroundColor = collectionView.window?.tintColor

//    client.subscribe(action.message.topic).bindTo()
//      { (collectionView, index, model) in
//      let indexPath = NSIndexPath(forItem: i, inSection: 0)
//      let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMap[action.type]!, forIndexPath: indexPath)
//      return cell as UICollectionViewCell
//    }.addDisposableTo(disposeBag)

    if let receivingCell = cell as? ReceivesMessages {
      receivingCell.subscribeForChanges(action, client: client, disposeBag: disposeBag)
    }

    if var sendingCell = cell as? SendsMessages {
      sendingCell.homeClient = client
      sendingCell.action = action
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