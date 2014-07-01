//
//  DevicesController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 30/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class DevicesController : UITableViewController, CBCentralManagerDelegate {
    
    var centralManager: CBCentralManager!
    var peripherals: Array<Device> = Array()
    
    class Device : NSObject {
        var peripheral: CBPeripheral!
        var RSSI: NSNumber!
        
        init(peripheral: CBPeripheral, RSSI: NSNumber) {
            self.peripheral = peripheral
            self.RSSI = RSSI
        }
        
        override func isEqual(object: AnyObject!) -> Bool {
            return (object as Device).peripheral.identifier == self.peripheral.identifier
        }
    }
    
    enum ScanningState {
        case Scanning
        case Idle
    }
    
    var scanningState: ScanningState = .Idle
    
    
    @IBAction func bleExplorationFinished (sender: AnyObject) {
        self.centralManager.stopScan()
        self.navigationController.dismissModalViewControllerAnimated(true)
    }
    
    @IBAction func bleScanStarted(sender: AnyObject) {
        if scanningState == .Idle {
            self.centralManager.scanForPeripheralsWithServices(nil, options: nil)
            self.navigationItem.rightBarButtonItem.title = "Stop"
            self.scanningState = .Scanning
        } else {
            self.centralManager.stopScan()
            self.navigationItem.rightBarButtonItem.title = "Scan"
            self.scanningState = .Idle
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: dispatch_get_main_queue())
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("BLE Manager updated state to: \(central.state)")
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: NSDictionary!, RSSI: NSNumber!) {
        println("peripheral discovered: \(peripheral.name), RSSI: \(RSSI)")
        var device = Device(peripheral: peripheral, RSSI: RSSI)
        var isNew = true
        for d in peripherals {
            if d.isEqual(device) {
                isNew = false
                d.RSSI = device.RSSI
            }
        }
        if isNew {
            peripherals.append(device)
        }
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return self.peripherals.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "ble_device_cell")
        cell.textLabel.text = "Name: \(peripherals[indexPath.row].peripheral.name)"
        cell.detailTextLabel.text = "RSSI: \(peripherals[indexPath.row].RSSI)"
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        bleScanStarted(self)
        centralManager.connectPeripheral(peripherals[indexPath.row].peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        bleScanStarted(self)
        var sc = storyboard.instantiateViewControllerWithIdentifier("ServicesController") as ServicesController
        sc.peripheral = peripheral
        self.navigationController.pushViewController(sc, animated: true)
    }
    
    func centralManager(central: CBCentralManager!, didFailToConnectPeripheral peripheral: CBPeripheral!, error: NSError!) {
        var alert = UIAlertView()
        alert.title = "Error"
        alert.message = "Cannot connect to \(peripheral.name)"
        alert.show()
    }
}