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

  var dashboards = [
    Dashboard(
      title: "Hildebrandpad",
      actions: [
        MessageViewModel(message: Message(topic: "lights/all", payloadString: "on", retain: false), description: "Alle lampen aan", type: .Button),
        MessageViewModel(message: Message(topic: "lights/all", payloadString: "off", retain: false), description: "Alle lampen uit", type: .Button),
        MessageViewModel(message: Message(topic: "lights/M/2", payloadString: "on", retain: true), description: "Bureaulamp", type: .Toggle),
        MessageViewModel(message: Message(topic: "lights/M/1", payloadString: "on", retain: true), description: "Staande lamp", type: .Toggle),
        MessageViewModel(message: Message(topic: "lights/M/3", payloadString: "on", retain: true), description: "Bed lampen", type: .Toggle),
        MessageViewModel(topic: "user/mathijs/home", description: "Mathijs thuis", type: .Display),

        //    MessageViewModel(topic: "hildebrandpad/temperature", description: "Kamer temperatuur", type: .Display),
        //    MessageViewModel(topic: "hildebrandpad/humidity", description: "Kamer luchtvochtigheid", type: .Display),
      ]
    ),
    Dashboard(
      title: "Bilderdijkstraat",
      actions: [
        MessageViewModel(message: Message(topic: "lights/M/1", payloadString: "on", retain: true), description: "Meidenkastje", type: .Toggle),

        MessageViewModel(message: Message(topic: "lights/M/4", payloadString: "on", retain: true), description: "Staande lamp zithoek", type: .Toggle),
        MessageViewModel(message: Message(topic: "lights/M/5", payloadString: "on", retain: true), description: "Lampen straatkant", type: .Toggle),

        MessageViewModel(message: Message(topic: "lights/E/1", payloadString: "on", retain: true), description: "Serre tafel", type: .Toggle),
        MessageViewModel(message: Message(topic: "lights/E/2", payloadString: "on", retain: true), description: "Serre lamp", type: .Toggle),
      ]
    ),
  ]

  var currentDashboard: Dashboard!

  let reuseMap: [ActionType : String] = [
    .Button: R.reuseIdentifier.buttonCell.identifier,
    .Toggle: R.reuseIdentifier.switchCell.identifier,
    .Display: R.reuseIdentifier.displayCell.identifier,
  ]

  var client: HomeClient!
  var disposeBag: DisposeBag!

  override func viewDidLoad() {
    super.viewDidLoad()
    client = MqttHomeClient(userDefaults: NSUserDefaults.standardUserDefaults())
    disposeBag = DisposeBag()
    currentDashboard = dashboards[0]

    client.connect().then {
      print("dashboard connected")
    }.trap { [weak self] error in
      self?.presentError(error)
    }

    collectionView?.delegate = self
    collectionView?.dataSource = self

    collectionView?.registerNib(R.nib.buttonCell)
    collectionView?.registerNib(R.nib.displayCell)
    collectionView?.registerNib(R.nib.switchCell)

    let inset: CGFloat = 16
    collectionView?.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }

  // MARK: Collection view data source

  override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentDashboard.actions.count
  }

  override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let action = currentDashboard.actions[indexPath.row]
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseMap[action.type]!, forIndexPath: indexPath)

    cell.layer.cornerRadius = 30
    cell.backgroundColor = collectionView.window?.tintColor

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