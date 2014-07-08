//
//  ExecutionUtils.swift
//  Weather
//
//  Created by Ivan Kravchenko on 02/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

import Foundation

class ExecutionUtils : NSObject {
    
    class func executeInMainThread(method: ()->()) {
        Performance_ObjCtoCPlusPlus.sortArrayCPlusPlus(18)
        if NSThread.isMainThread() {
            method()
        } else {
            dispatch_async(dispatch_get_main_queue(), method)
        }
    }
}