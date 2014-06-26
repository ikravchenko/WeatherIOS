//
//  ViewController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 25/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UITableViewController, NSXMLParserDelegate, UITableViewDataSource {
    
    var weatherEntries: Array<WeatherEntry> = Array<WeatherEntry>()
    
    @IBAction func refreshClicked(sender : AnyObject) {
        weatherEntries.removeAll(keepCapacity: false)
        downloadWeather()
    }
    
    override func viewDidLoad() {
        println("View Did Load")
        self.tableView.dataSource = self
        self.tableView.delegate = self
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
    
    class WeatherEntry : NSObject {
        var from: String?
        var to: String?
        var name: String?
        var temperature: Float?
        func isWarm () -> Bool {
            return temperature > 15;
        }
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
//        for  w in weatherEntries {
//            println(w.name)
//            println(w.from)
//            println(w.to)
//            println(w.temperature)
//            println(w.isWarm())
//        }
        println("Weather entries count \(weatherEntries.count)")
        dispatch_async(dispatch_get_main_queue(), {
            self.tableView.reloadData()
        })
    }
    
    func numberOfSections() -> Int {
        return 1;
    }
    
    func numberOfRowsInSection(section: Int) -> Int {
        return weatherEntries.count;
    }
    
    func cellForRowAtIndexPath(indexPath: NSIndexPath!) -> UITableViewCell! {
        let REUSE_IDENTIFIER = "weather_table_cell"
        var cell = tableView.dequeueReusableCellWithIdentifier(REUSE_IDENTIFIER) as UITableViewCell
        if (cell == nil) {
            cell = UITableViewCell(style: .Subtitle, reuseIdentifier: REUSE_IDENTIFIER)
        }
        var entry = weatherEntries[indexPath.row]
        cell.textLabel.text = "From: \(entry.from) to: \(entry.to)"
        cell.detailTextLabel.text = "\(entry.name), temperature:\(entry.temperature)"
        cell.backgroundColor = UIColor.blackColor()

        return cell
    }
    
    override func tableView(tableView: UITableView!, didSelectRowAtIndexPath indexPath: NSIndexPath!) {
        println("Row clicled at \(indexPath.row)")
    }
    
}

