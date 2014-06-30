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
    @IBOutlet var warmSwitch : UISwitch
    @IBOutlet var saveButton : UIButton
    @IBOutlet var deleteButton : UIButton
    
    @IBAction func entrySaved(sender: AnyObject) {
        var error: NSError?
        entry.setValue(timeFromText.text, forKey: "from")
        entry.setValue(timeToText.text, forKey: "to")
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
        
        
        timeFromText.text = entry.valueForKey("from") as String
        timeToText.text = entry.valueForKey("to") as String
        let temperature = NSString(format:"%.2f", entry.valueForKey("temperature") as Float)
        var name = entry.valueForKey("name") as String
        forecastText.text = "\(name), temperature: \(temperature)"
        warmSwitch.setOn(entry.valueForKey("isWarm") as Bool, animated: true)
    }

}
