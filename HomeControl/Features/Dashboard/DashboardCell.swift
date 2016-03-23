//
//  DashboardCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 19/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit

protocol DashboardCell {
  func subscribe(client: HomeClient)
}
