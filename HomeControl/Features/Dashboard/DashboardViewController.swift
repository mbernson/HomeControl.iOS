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

let dashboards = [
  Dashboard(
    title: "Hildebrandpad",
    actions: [
      MessageViewModel(message: Message(topic: "lights/all", payloadString: "on", retain: false), description: "Alle lampen aan", type: .button),
      MessageViewModel(message: Message(topic: "lights/all", payloadString: "off", retain: false), description: "Alle lampen uit", type: .button),
      MessageViewModel(message: Message(topic: "lights/M/2", payloadString: "on", retain: true), description: "Bureaulamp", type: .toggle),
      MessageViewModel(message: Message(topic: "lights/M/1", payloadString: "on", retain: true), description: "Staande lamp", type: .toggle),
      MessageViewModel(message: Message(topic: "lights/M/3", payloadString: "on", retain: true), description: "Bed lampen", type: .toggle),
      MessageViewModel(topic: "user/mathijs/home", description: "Mathijs thuis", type: .display),

      //    MessageViewModel(topic: "hildebrandpad/temperature", description: "Kamer temperatuur", type: .Display),
      //    MessageViewModel(topic: "hildebrandpad/humidity", description: "Kamer luchtvochtigheid", type: .Display),
    ]
  ),
  Dashboard(
    title: "Bilderdijkstraat",
    actions: [
      MessageViewModel(message: Message(topic: "lights/M/1", payloadString: "on", retain: true), description: "Meidenkastje", type: .toggle),

      MessageViewModel(message: Message(topic: "lights/M/4", payloadString: "on", retain: true), description: "Staande lamp zithoek", type: .toggle),
      MessageViewModel(message: Message(topic: "lights/M/5", payloadString: "on", retain: true), description: "Lampen straatkant", type: .toggle),

      MessageViewModel(message: Message(topic: "lights/E/1", payloadString: "on", retain: true), description: "Serre tafel", type: .toggle),
      MessageViewModel(message: Message(topic: "lights/E/2", payloadString: "on", retain: true), description: "Serre lamp", type: .toggle),
    ]
  ),
]

class DashBoardViewController: UICollectionViewController {

  var currentDashboard: Dashboard! {
    didSet {
      applyDashboard()
    }
  }

  let reuseMap: [ActionType : String] = [
    .button: R.reuseIdentifier.buttonCell.identifier,
    .toggle: R.reuseIdentifier.switchCell.identifier,
    .display: R.reuseIdentifier.displayCell.identifier,
  ]

  var client: HomeClient!
  var disposeBag: DisposeBag!

  override func viewDidLoad() {
    super.viewDidLoad()

    client = MqttHomeClient()
    disposeBag = DisposeBag()
    currentDashboard = dashboards[0]

    client.connect().then {
      self.navigationItem.title = "\(self.currentDashboard.title) [Connected]"
    }.trap { [weak self] error in
      self?.presentError(error)
    }

    collectionView?.delegate = self
    collectionView?.dataSource = self

    collectionView?.register(R.nib.buttonCell)
    collectionView?.register(R.nib.switchCell)
    collectionView?.register(R.nib.displayCell)

    let inset: CGFloat = 16
    collectionView?.contentInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
  }

  fileprivate func applyDashboard() {
    disposeBag = DisposeBag()
    collectionView?.reloadData()
  }

  // MARK: Collection view data source

  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }

  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return currentDashboard.actions.count
  }

  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let action = currentDashboard.actions[(indexPath as NSIndexPath).row]
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseMap[action.type]!, for: indexPath)

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

  override func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
    return true
  }
}
