//
//  ViewController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 25/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UITableViewController, NSXMLParserDelegate {
    
    var weatherEntries: Array<WeatherEntry> = Array<WeatherEntry>()
    var fetchedObjects: Array<NSManagedObject> = Array<NSManagedObject>()
    var context: NSManagedObjectContext!
    
    
    @IBAction func refreshClicked(sender : AnyObject) {
        weatherEntries.removeAll(keepCapacity: false)
        for o in fetchAllWeatherEntries() {
            self.context.deleteObject(o)
        }
        downloadWeather()
    }
    
    @IBAction func createEntryClicked(sender : AnyObject) {
        var sb = UIStoryboard(name: "Main", bundle: nil)
        var vc : DetailsController! = sb.instantiateViewControllerWithIdentifier("DetailsController") as DetailsController
        vc.masterControllerDelegate = self
        vc.context = self.context
        navigationController.pushViewController(vc, animated: true)
    }
    
    override func viewDidLoad() {
        var app = UIApplication.sharedApplication().delegate as AppDelegate
        context = app.managedObjectContext
        reloadData()
        super.viewDidLoad()
    }

    func downloadWeather() {
        var url: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?q=Bonn&mode=xml&APPID=7732b247cdb20b941ea963a87e8b8269")
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error) {
                println(error.localizedDescription)
            }
            
            var parser = NSXMLParser(data: data)
            parser.shouldProcessNamespaces = false
            parser.shouldReportNamespacePrefixes = false
            parser.shouldResolveExternalEntities = false
            parser.delegate = self
            if !parser.parse() {
                println("XML Error")
            }
        })
        task.resume()
    }
        
    var current: WeatherEntry?
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!,attributes attributeDict: NSDictionary!) {
        if (elementName == "time") {
            current = WeatherEntry()
            weatherEntries.append(current!)
            var formatter = NSDateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            current!.from = formatter.dateFromString(attributeDict["from"] as String)
            current!.to = formatter.dateFromString(attributeDict["to"] as String)
            println(current!.from)
            println(current!.to)
        } else if (elementName == "symbol") {
            if (current != nil) {
                current!.name = attributeDict["name"] as? String
            }
        } else if (elementName == "temperature") {
            if (current != nil) {
                current!.temperature = attributeDict["value"]?.floatValue
                current!.isWarm = attributeDict["value"]?.floatValue > 15
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        println("Weather entries count \(weatherEntries.count)")
        for we in weatherEntries {
            var entry = NSEntityDescription.insertNewObjectForEntityForName("Weather", inManagedObjectContext: self.context) as NSManagedObject
            entry.setValue(we.from, forKey: "from")
            entry.setValue(we.to, forKey: "to")
            entry.setValue(we.name, forKey: "name")
            entry.setValue(we.temperature, forKey: "temperature")
            entry.setValue(we.isWarm, forKey: "isWarm")
            var error: NSError?
            if !self.context.save(&error) {
                println("Failed to save with core data: \(error?.localizedDescription)")
            }
        }
        
        reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return fetchedObjects.count
    }
    
    func fetchAllWeatherEntries() -> Array<NSManagedObject> {
        let fetchRequest = NSFetchRequest()
        let entity = NSEntityDescription.entityForName("Weather", inManagedObjectContext: self.context)
        fetchRequest.entity = entity
        
        fetchRequest.fetchBatchSize = 1
        
        let sortDescriptor = NSSortDescriptor(key: "from", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchError: NSError?
        return context.executeFetchRequest(fetchRequest, error: &fetchError) as Array<NSManagedObject>
    }
    
    func reloadData() {
        fetchedObjects = fetchAllWeatherEntries()
        if NSThread.isMainThread() {
            self.tableView.reloadData()
        } else {
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let REUSE_IDENTIFIER = "weather_table_cell"
        var cell: UITableViewCell! = tableView?.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            var  cell = UITableViewCell(style: .Subtitle, reuseIdentifier: REUSE_IDENTIFIER)
        }
        var formatter = NSDateFormatter()
        formatter.dateFormat = "dd-MM:HH:mm"
        var entry = fetchedObjects[indexPath.row]
        var from = formatter.stringFromDate(entry.valueForKey("from") as NSDate)
        var to = formatter.stringFromDate(entry.valueForKey("to") as NSDate)
        var name = entry.valueForKey("name") as String
        var t = entry.valueForKey("temperature") as Float
        var warm = entry.valueForKey("isWarm") as Bool
        cell.textLabel.text = "From: \(from) to: \(to)"
        let temperature = NSString(format:"%.2f", t)
        cell.detailTextLabel.text = "\(name), temperature:\(temperature)"
        cell.accessoryType = warm ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var sb = UIStoryboard(name: "Main", bundle: nil)
        var vc : DetailsController! = sb.instantiateViewControllerWithIdentifier("DetailsController") as DetailsController
        vc.masterControllerDelegate = self
        vc.context = self.context
        vc.entry = fetchedObjects[indexPath.row]
        navigationController.pushViewController(vc, animated: true)
    }
    
}

