//
//  BLEUtils.h
//  Weather
//
//  Created by Ivan Kravchenko on 01/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface BLEUtils : NSObject
    +(int) decodeHRValue:(NSData *)data;
    +(NSString *) decodeHRLocation:(NSData *)data;
@end
