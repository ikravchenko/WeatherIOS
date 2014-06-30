//
//  DetailsController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 27/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Foundation

class DetailsController: UIViewController {
    var entry: WeatherEntry?
    
    @IBOutlet var timeFromText : UITextField
    @IBOutlet var timeToText : UITextField
    @IBOutlet var forecastText : UITextField
    @IBOutlet var warmSwitch : UISwitch
    
    @IBAction func entryEditingCancelled(sender: AnyObject) {
    }
    
    @IBAction func entryEditingDone(sender: AnyObject) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (entry == nil) {
            return;
        }
        
        
        timeFromText.text = entry!.from
        timeToText.text = entry!.to
        let temperature = NSString(format:"%.2f", entry!.temperature!)
        forecastText.text = "\(entry!.name), temperature: \(temperature)"
        warmSwitch.setOn(entry!.isWarm!, animated: true)
        
    }

}
