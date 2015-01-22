//
//  SQLite.h
//
//  Created by Benjamin Avond on 05/04/2014.
//  Copyright (c) 2014 Atomnium. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface SQLite : NSObject
{
    NSString *databaseName;
	NSString *databasePath;
}

-(id) initDatabase;
-(void) checkAndCreateDatabase;


-(void)Query:(const char*)query;
-(NSArray*)QuerySelect:(NSString*)query;
-(int)QueryInsert:(NSString*)query;
-(NSInteger)QueryCount:(NSString*)query;

-(NSString*)Get_DatabasePath;
-(void)logDatabasePath;


@end
