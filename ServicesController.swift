//
//  ServicesController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 01/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class ServicesController : UITableViewController {
    var peripheral: CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = peripheral.name
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "service_cell")
        cell.textLabel.text = "Service: \(indexPath.row)"
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cc = storyboard.instantiateViewControllerWithIdentifier("CharachteristicsController") as CharactericticsController
        self.navigationController.pushViewController(cc, animated: true)
    }
}