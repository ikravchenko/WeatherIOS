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
    var entry: NSManagedObject!
    var context: NSManagedObjectContext!
    var masterControllerDelegate: ViewController!
    
    @IBOutlet var timeFromText : UITextField
    @IBOutlet var timeToText : UITextField
    @IBOutlet var forecastText : UITextField
    @IBOutlet var temperatureText : UITextField
    @IBOutlet var warmSwitch : UISwitch
    @IBOutlet var saveButton : UIButton
    @IBOutlet var deleteButton : UIButton
    
    @IBAction func entrySaved(sender: AnyObject) {
        var error: NSError?
        entry.setValue(forecastText.text, forKey: "name")
        entry.setValue(warmSwitch.on, forKey: "isWarm")
        if !context.save(&error) {
            println("Unable to save entry")
        }
        self.navigationController.popViewControllerAnimated(true)
        self.masterControllerDelegate.reloadData()
    }
    
    @IBAction func entryDeleted(sender: AnyObject) {
        context.deleteObject(entry)
        var error: NSError?
        if !context.save(&error) {
            println("Unable to delete entry")
        }
        self.navigationController.popViewControllerAnimated(true)
        self.masterControllerDelegate.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (entry == nil) {
            return;
        }
        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM:HH:mm"
        timeFromText.text = formatter.stringFromDate(entry.valueForKey("from") as NSDate)
        timeToText.text = formatter.stringFromDate(entry.valueForKey("to") as NSDate)
        let temperature = NSString(format:"%.2f", entry.valueForKey("temperature") as Float)
        forecastText.text = entry.valueForKey("name") as String
        temperatureText.text = temperature
        warmSwitch.setOn(entry.valueForKey("isWarm") as Bool, animated: true)
    }

}
