//
//  WeatherEntry.swift
//  Weather
//
//  Created by Ivan Kravchenko on 27/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation

class WeatherEntry : NSObject {
    var from: NSDate?
    var to: NSDate
    var name: String?
    var temperature: Float?
    var isWarm: Bool?
    
    init() {
        self.from = NSDate()
        self.to = NSDate()
    }
}
