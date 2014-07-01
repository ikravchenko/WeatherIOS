//
//  CharachteristicsController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 01/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation
import UIKit

class CharactericticsController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Charachteristics"
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = UITableViewCell(style: .Subtitle, reuseIdentifier: "ch_cell")
        cell.textLabel.text = "Charachteristic: \(indexPath.row)"
        return cell
    }
}