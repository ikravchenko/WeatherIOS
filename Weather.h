//
//  Weather.h
//  Weather
//
//  Created by Ivan Kravchenko on 27/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Weather : NSManagedObject

@property (nonatomic, retain) NSString * from;
@property (nonatomic, retain) NSString * to;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSNumber * isWarm;
@property (nonatomic, retain) NSNumber * id;

@end
