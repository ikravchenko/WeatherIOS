//
//  DBManager.h
//  Weather
//
//  Created by Ivan Kravchenko on 27/06/14.
//  Copyright (c) 2014 DORMA. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(BOOL)createDB;

@end