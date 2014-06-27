//
//  ViewController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 25/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController, NSXMLParserDelegate {
    
    var weatherEntries: Array<WeatherEntry> = Array<WeatherEntry>()
    var db: DBManager?

    
    @IBAction func refreshClicked(sender : AnyObject) {
        weatherEntries.removeAll(keepCapacity: false)
        downloadWeather()
    }
    
    override func viewDidLoad() {
        db = DBManager()
        if db!.createDB() {
            println("Db successfully created")
        } else {
            println("Not possible to create a db")
        }
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
            }
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
        println("Weather entries count \(weatherEntries.count)")
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView!) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return weatherEntries.count;
    }
    
    override func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let REUSE_IDENTIFIER = "weather_table_cell"
        var cell: UITableViewCell! = tableView?.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER, forIndexPath: indexPath) as UITableViewCell
        if (cell == nil) {
            var  cell = UITableViewCell(style: .Subtitle, reuseIdentifier: REUSE_IDENTIFIER)
        }
        var entry = weatherEntries[indexPath.row]
        cell.textLabel.text = "From: \(entry.from) to: \(entry.to)"
        let temperature = NSString(format:"%.2f", entry.temperature!)
        cell.detailTextLabel.text = "\(entry.name), temperature:\(temperature)"
        cell.accessoryType = entry.isWarm() ? .Checkmark : .None
        
        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        var sb = UIStoryboard(name: "Main", bundle: nil)
        var vc : DetailsController! = sb.instantiateViewControllerWithIdentifier("DetailsController") as DetailsController
        vc.entry = weatherEntries[indexPath.row]
        navigationController.pushViewController(vc, animated: true)
    }
    
}

