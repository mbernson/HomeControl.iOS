//
//  DashboardCollectionViewCell.swift
//  HomeControl
//
//  Created by Mathijs Bernson on 21/03/16.
//  Copyright © 2016 Duckson. All rights reserved.
//

import UIKit
import RxSwift

protocol ReceivesMessages {
  func subscribeForChanges(action: MessageAction, client: HomeClient, disposeBag: DisposeBag)
}