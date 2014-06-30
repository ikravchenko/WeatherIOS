//
//  Weather.h
//  Weather
//
//  Created by Ivan Kravchenko on 30/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSDate * from;
@property (nonatomic, retain) NSNumber * isWarm;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSDate * to;

@end
