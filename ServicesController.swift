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

class ServicesController : UITableViewController, CBPeripheralDelegate {
    let HR_SERVICE = CBUUID.UUIDWithString("0000180D-0000-1000-8000-00805F9B34FB")
    var peripheral: CBPeripheral!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = peripheral.name
        self.peripheral.delegate = self
        self.peripheral.discoverServices(nil)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        if let s = peripheral.services {
            return s.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: .Default, reuseIdentifier: "service_cell")
        if (peripheral.services[indexPath.row] as CBService).UUID.isEqual(HR_SERVICE) {
            cell.textLabel.text = "Heart Rate Service"
        } else {
            cell.textLabel.text = "\((peripheral.services[indexPath.row] as CBService).UUID)"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var cc = storyboard.instantiateViewControllerWithIdentifier("CharachteristicsController") as CharactericticsController
        self.navigationController.pushViewController(cc, animated: true)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        self.tableView.reloadData()
    }
}