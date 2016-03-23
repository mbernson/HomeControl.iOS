//
//  DashboardViewController.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 22/01/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

class DashBoardViewController: UICollectionViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    self.navigationItem.title = "Dashboard"
    self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Send custom", style: .Plain, target: self, action: #selector(sendButtonPressed))
  }

  @objc private func sendButtonPressed() {
    print("send")
  }
}

struct DashboardViewModel {
  //  let cells: [Cell]
}