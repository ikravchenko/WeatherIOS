//
//  DevicesController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 30/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation
import UIKit

class DevicesController : UITableViewController {
    
    @IBAction func bleExplorationFinished (sender: AnyObject) {
        self.navigationController.dismissModalViewControllerAnimated(true)
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
    }
}