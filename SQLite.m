//  SQLite.m
//
//  Created by Benjamin Avond on 05/04/2014.
//  Copyright (c) 2014 Atomnium. All rights reserved.
//

#import "SQLite.h"

@implementation SQLite

-(id) initDatabase{
	//On définit le nom de la base de données
    databaseName = @"sqlite.db";
    
	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentsDir = [documentPaths objectAtIndex:0];
    
	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
	return self;
}

-(void)logDatabasePath
{
    NSLog(@"%@", databasePath);
}

-(NSString*)Get_DatabasePath
{
    
    return databasePath;
}

-(void) checkAndCreateDatabase{
	// On vérifie si la BDD a déjà été sauvegardée dans l'iPhone de l'utilisateur
	BOOL success;
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
    [self checkAndCreateTables];
    
    
	success = [fileManager fileExistsAtPath:databasePath];
    if(success) return;
	
	
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    if([fileManager fileExistsAtPath:databasePathFromApp])
    {
        [fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
        NSLog(@"Init Sqlite : Crée");
    }
    else
    {
        NSLog(@"Le fichier SQLITE d'origine n'a pas été trouvé.");
    }
}


-(void)checkAndCreateTables
{
    
}

-(void)Query:(const char*)query
{
    NSLog(@"Query : %s", query);
    sqlite3 *database;
    @try{
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            sqlite3_exec(database, query, NULL, NULL, NULL);
            
            sqlite3_close(database);
        }
        else
        {
            NSLog(@"Query Select Error: %s", sqlite3_errmsg(database));
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    @finally {
        sqlite3_close(database);
        //NSLog(@"Database close");
    }
	//On ferme la BDD
}

-(NSArray*)QuerySelect:(NSString*)query
{
    NSMutableArray* tempArray = [NSMutableArray array];
    NSLog(@"Query : %@", query);
    sqlite3 *database;
    
    @try{
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
        {
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
                
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    int columnsCount = sqlite3_data_count(compiledStatement);
                    NSMutableDictionary* dico = [NSMutableDictionary dictionary];
                    for(int i = 0; i < columnsCount; i++)
                    {
                        int colType = sqlite3_column_type(compiledStatement, i);
                        const char* name = sqlite3_column_name(compiledStatement, i);
                        NSString* columnName = [NSString stringWithUTF8String:name];
                        
                        if([columnName isEqualToString:@"rDateCreation"])
                            NSLog(@"test");
                        
                        if (colType == SQLITE_TEXT){
                            NSString* s = [NSString stringWithCString:(char *)sqlite3_column_text(compiledStatement, i) encoding:NSUTF8StringEncoding];
                            if([s isEqualToString:@"(null)"])
                                s = @"";
                            if(!s)
                                s = @"";
                            
                            dico[columnName] = s;
                        }
                        else if (colType == SQLITE_INTEGER)
                            dico[columnName] = [NSNumber numberWithInt:sqlite3_column_int(compiledStatement, i)];
                        
                        else if (colType == SQLITE_FLOAT)
                            dico[columnName] = [NSNumber numberWithFloat:(float)sqlite3_column_double(compiledStatement, i)];
                    }
                    
                    [tempArray addObject:dico];
                }
            }
            else
            {
                NSLog(@"Query Select Error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(compiledStatement), compiledStatement = nil;
            
        }
    }
    
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    @finally {
        sqlite3_close(database);
    }
    
    return [NSArray arrayWithArray:tempArray];
}

-(int)QueryInsert:(NSString*)query
{
    int64_t sId = -1;
    NSLog(@"Query Insert : %@", query);
    sqlite3 *database;
    @try{
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK) {
            sqlite3_exec(database, [query UTF8String], NULL, NULL, NULL);
            sId = sqlite3_last_insert_rowid(database);
            sqlite3_close(database);
        }
        else
        {
            NSLog(@"Query Select Error: %s", sqlite3_errmsg(database));
        }
    }
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    @finally {
        sqlite3_close(database);
    }
    return (int)sId;
    //On ferme la BDD
}

-(NSInteger)QueryCount:(NSString*)query
{
    NSInteger count = 0;
    NSLog(@"Query : %@", query);
    sqlite3 *database;
    
    @try{
        if(sqlite3_open([databasePath UTF8String], &database) == SQLITE_OK)
        {
            sqlite3_stmt *compiledStatement;
            if(sqlite3_prepare_v2(database, [query UTF8String], -1, &compiledStatement, NULL) == SQLITE_OK) {
                
                
                while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                {
                    count = sqlite3_column_int(compiledStatement, 0);
                    break;
                }
            }
            else
            {
                NSLog(@"Query Select Error: %s", sqlite3_errmsg(database));
            }
            sqlite3_finalize(compiledStatement), compiledStatement = nil;
            
        }
    }
    
    @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    @finally {
        sqlite3_close(database);
    }
    
    return count;
}

@end
