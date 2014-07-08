//
//  BLEUtils.m
//  Weather
//
//  Created by Ivan Kravchenko on 01/07/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

#import "BLEUtils.h"
#import "ObjCtoCPlusPlus.h"

@implementation BLEUtils

+(int) decodeHRValue:(NSData *)data
{
    const uint8_t *value = [data bytes];
    int bpmValue = 0;
    if ((value[0] & 0x01) == 0) {
        NSLog(@"8 bit HR Value");
        bpmValue = value[1];
    }
    else {
        NSLog(@"16 bit HR Value");
        bpmValue = CFSwapInt16LittleToHost(*(uint16_t *)(&value[1]));
    }
    NSLog(@"BPM: %d",bpmValue);
    return bpmValue;
}

+(NSString *) decodeHRLocation:(NSData *)data
{
    [Performance_ObjCtoCPlusPlus sortArrayCPlusPlus: 18];
    const uint8_t *location = [data bytes];
    NSString *hrmLocation;
    switch (location[0]) {
        case 0:
            hrmLocation = @"Other";
            break;
        case 1:
            hrmLocation = @"Chest";
            break;
        case 2:
            hrmLocation = @"Wrist";
            break;
        case 3:
            hrmLocation = @"Finger";
            break;
        case 4:
            hrmLocation = @"Hand";
            break;
        case 5:
            hrmLocation = @"Ear Lobe";
            break;
        case 6:
            hrmLocation = @"Foot";
            break;
        default:
            hrmLocation = @"Invalid";
            break;
    }
    NSLog(@"HRM location is %@",hrmLocation);
    return hrmLocation;
}
@end
