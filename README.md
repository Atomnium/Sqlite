# Sqlite

This is my Sqlite Manager. Maybe things are missing, and I don't check the queries you send. If you send a SELECT query to the QueryInsert method, I don't what will happen because I created this Manager for myself and I won't do this mistake.
I hope it will help some people.

How to use it:

When you use the class, instatiate it with [[Sqlite alloc] initDatabase].
In the AppDelegate->applicationDidFinishLaunching method, you can call the checkAndCreateDatabase method to be sure the database exists or is created. This method will call the checkAndCreateTables method. You have to feed it with your own queries "CREATE TABLE IF NOT EXISTS" like below : 

NSString* queryGeoloc = @"create table if not exists  'Geoloc' ('ID' INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT UNIQUE,'IDContact'	INTEGER UNIQUE, 'latitude' FLOAT, 'longitude' FLOAT)";
[self Query:queryGeoloc];

The query methods : 
-(void)Query:(NSString*)query;
Will only execute the query you send in parameter. Use it to CREATE, DELETE, UPDATE, for exemple

-(NSArray*)QuerySelect:(NSString*)query;
Will return an array of dictionnaries. The keys are the name of the fields declared in the SELECT clause.
Integers/Float are NSNumbers because we can't store NSIntegers/Float in dictionnaries. 

-(int)QueryInsert:(NSString*)query;
Execute an insert query and returns the index of the new created record.

-(NSInteger)QueryCount:(NSString*)query;
Use it to do a SELECT COUNT query.
