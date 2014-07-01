//
//  CharachteristicsController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 01/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class CharactericticsController : UITableViewController, CBPeripheralDelegate {
    let HRS_SENSOR_UUID = CBUUID.UUIDWithString("00002A37-0000-1000-8000-00805F9B34FB");
    let HRS_SENSOR_LOCATION_UUID = CBUUID.UUIDWithString("00002A38-0000-1000-8000-00805F9B34FB");
    
    var peripheral: CBPeripheral!
    var service: CBService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheral.delegate = self
        peripheral.discoverCharacteristics(nil, forService: service)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return service.characteristics == nil ? 0 : service.characteristics.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "ch_cell")
        var c = service.characteristics[indexPath.row] as CBCharacteristic
        switch c.UUID {
            case HRS_SENSOR_UUID:
                cell.textLabel.text = "Heart rate"
                if c.value != nil {
                    cell.detailTextLabel.text = "\(BLEUtils.decodeHRValue(c.value))"
                }
            case HRS_SENSOR_LOCATION_UUID:
                cell.textLabel.text = "Sensor location"
                if c.value != nil {
                    cell.detailTextLabel.text = BLEUtils.decodeHRLocation(c.value)
                }
            default:
                cell.textLabel.text = "\(c.UUID)"
                cell.detailTextLabel.text = ""
        }
        
        return cell
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        println("didDiscoverCharacteristicsForService")
        for c in service.characteristics as CBCharacteristic[] {
            if c.UUID.isEqual(HRS_SENSOR_UUID) {
                peripheral.setNotifyValue(true, forCharacteristic: c)
            }
            peripheral.readValueForCharacteristic(c)
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didUpdateValueForCharacteristic characteristic: CBCharacteristic!, error: NSError!) {
        println("didUpdateValueForCharacteristic, error:\(error), value:\(characteristic.value)")
        if NSThread.isMainThread() {
            self.tableView.reloadData()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        peripheral.delegate = nil
    }
}