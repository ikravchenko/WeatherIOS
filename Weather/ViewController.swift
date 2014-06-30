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
    var context: NSManagedObjectContext!
    var fetchedObjects: Array<NSManagedObject> = Array<NSManagedObject>()
    
    @IBAction func refreshClicked(sender : AnyObject) {
        weatherEntries.removeAll(keepCapacity: false)
        downloadWeather()
    }
    
    override func viewDidLoad() {
        var app = UIApplication.sharedApplication().delegate as AppDelegate
        context = app.managedObjectContext
        downloadWeather()
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
            current!.from = attributeDict["from"] as NSString
            current!.to = attributeDict["to"] as NSString
        } else if (elementName == "symbol") {
            if (current != nil) {
                current!.name = attributeDict["name"] as NSString
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
        var i: Int = 0
        for we in weatherEntries {
            var entry = NSEntityDescription.insertNewObjectForEntityForName("Weather", inManagedObjectContext: self.context) as NSManagedObject
            entry.setValue(i, forKey: "id")
            entry.setValue(we.from, forKey: "from")
            entry.setValue(we.to, forKey: "to")
            entry.setValue(we.name, forKey: "name")
            entry.setValue(we.temperature, forKey: "temperature")
            entry.setValue(we.isWarm, forKey: "isWarm")
            var error: NSError?
            if !self.context.save(&error) {
                println("Failed to save with core data: \(error?.localizedDescription)")
            } else {
                i++
            }
        }
        
        let fetchRequest = NSFetchRequest()
        // Edit the entity name as appropriate.
        let entity = NSEntityDescription.entityForName("Weather", inManagedObjectContext: self.context)
        fetchRequest.entity = entity
        
        // Set the batch size to a suitable number.
        fetchRequest.fetchBatchSize = 1
        
        // Edit the sort key as appropriate.
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        var fetchError: NSError?
        fetchedObjects = context.executeFetchRequest(fetchRequest, error: &fetchError) as Array<NSManagedObject>
        for fo in fetchedObjects {
            println(fo.valueForKey("name"))
        }
        
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return fetchedObjects.count
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let REUSE_IDENTIFIER = "weather_table_cell"
        var cell: UITableViewCell! = tableView?.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            var  cell = UITableViewCell(style: .Subtitle, reuseIdentifier: REUSE_IDENTIFIER)
        }
        var entry = fetchedObjects[indexPath.row]
        var from : AnyObject! = entry.valueForKey("from") as String
        var to = entry.valueForKey("to") as String
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
        vc.entry = weatherEntries[indexPath.row]
        navigationController.pushViewController(vc, animated: true)
    }
    
}

