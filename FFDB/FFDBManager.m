//
//  FFDBManager.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDBManager.h"
#import "FFDataBaseModel+Sqlite.h"

@implementation FFDBManager

+ (NSString *)databasePath
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *executableFile = [infoDictionary objectForKey:(NSString *)kCFBundleExecutableKey];
    NSString *datebaseName = [NSString stringWithFormat:@"%@.sqlite",executableFile];
    NSString *databasePath = [[NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES) lastObject]stringByAppendingPathComponent:datebaseName];
    return databasePath;
}

+ (FMDatabase *)database
{

    FMDatabase *database = [FMDatabase databaseWithPath:[FFDBManager databasePath]];
    return database;
}

+ (void)insertObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
//    [queue inDatabase:^(FMDatabase *db) {
//        for (FFDataBaseModel *dbModel in objectList)
//        {
//            [db executeUpdateWithSqlstatement:[dbModel insertObjectSqlstatement]];
//        }
//    }];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [dbModel insertObjectSqlstatement];
            BOOL res = [db executeUpdate:sql];

        }
    }];
}

@end
