//
//  ViewController.swift
//  Weather
//
//  Created by Ivan Kravchenko on 25/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController, NSXMLParserDelegate {
    
    var weatherEntries: Array<WeatherEntry> = Array<WeatherEntry>()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        downloadWeather()
    }
    
    override func loadView() {
        var tableView = UITableView()
        self.view = tableView;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func downloadWeather() {
        
        // The iTunes API wants multiple terms separated by + symbols, so replace spaces with + signs
        var url: NSURL = NSURL(string: "http://api.openweathermap.org/data/2.5/forecast?q=Bonn&mode=xml&APPID=7732b247cdb20b941ea963a87e8b8269")
        var session = NSURLSession.sharedSession()
        var task = session.dataTaskWithURL(url, completionHandler: {data, response, error -> Void in
            println("Task completed")
            if(error) {
                // If there is an error in the web request, print it to the console
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
            dispatch_async(dispatch_get_main_queue(), {
//                self.tableData = results
//                self.appsTableView.reloadData()
                })
            })
        task.resume()
    }
    
    class WeatherEntry : NSObject {
        var from: String?
        var to: String?
        var name: String?
        var temperature: Float?
        var isWarm : Bool?
    }
    
    var current: WeatherEntry?
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!,attributes attributeDict: NSDictionary!) {
        if (elementName == "time") {
            current = WeatherEntry()
            current!.from = attributeDict["from"] as NSString
            current!.to = attributeDict["to"] as NSString
        } else if (elementName == "symbol") {
            if (current != nil) {
                current!.name = attributeDict["name"] as NSString
            }
        } else if (elementName == "temperature") {
            if (current != nil) {
                current!.temperature = attributeDict["value"]?.floatValue
                current!.isWarm = current!.temperature? > 15
            }
        }
    }
    
    func parser(parser: NSXMLParser!, didEndElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!) {
        if (elementName == "time" && current != nil) {
            weatherEntries.append(current!)
        }
    }
    
    func parserDidEndDocument(parser: NSXMLParser!) {
//        for  w in weatherEntries {
//            println(w.name)
//            println(w.from)
//            println(w.to)
//            println(w.temperature)
//            println(w.isWarm)
//        }
    }
    
    
}

