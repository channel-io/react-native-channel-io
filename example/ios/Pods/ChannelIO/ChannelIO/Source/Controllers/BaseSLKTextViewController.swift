//
//  SLKTextViewController.swift
//  CHPlugin
//
//  Created by 이수완 on 2017. 2. 22..
//  Copyright © 2017년 ZOYI. All rights reserved.
//

import UIKit
import CHSlackTextViewController

class BaseSLKTextViewController: SLKTextViewController {
  override var tableView: UITableView {
    get {
      return super.tableView!
    }
  }
}
