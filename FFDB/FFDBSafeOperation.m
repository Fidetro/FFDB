//
//  FFDBSafeOperation.m
//  FFDB
//
//  Created by Fidetro on 2017/5/15.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDBSafeOperation.h"
#import "FFDBLog.h"

@implementation FFDBSafeOperation

+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass
{
    return [FFDBSafeOperation selectObjectWithFFDBClass:dbClass format:nil];
}

+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    NSMutableArray *objectList = [NSMutableArray array];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *resultSet;
        resultSet = [db executeQuery:[dbClass selectObjectSqlstatementWithFormat:format]];
        while ([resultSet next])
        {
            
            id object = [[dbClass alloc]init];
            for (NSString *propertyname in [dbClass propertyOfSelf])
            {
                NSString *objStr = [[resultSet stringForColumn:propertyname]length] == 0 ? @"" :[resultSet stringForColumn:propertyname];
                [object setPropertyWithName:propertyname object:objStr];
            }
            [object setPropertyWithName:@"primaryID" object:[resultSet stringForColumn:@"primaryID"]];
            [objectList addObject:object];
        }
    }];
    return [objectList copy];
}

+ (void)insertObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [dbModel insertObjectSqlstatement];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                FFDBDLog(@"error");
            }
            
        }
    }];
}

+ (void)updateObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [dbModel updateObjectSqlStatementWithColumns:[[dbModel class]propertyOfSelf]];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                FFDBDLog(@"error");
            }
            
        }
    }];
}

+ (BOOL)updateObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:[NSString stringWithFormat:@"update `%@` %@",[dbClass getTableName],format]];
    }];
    return result;
}

+ (void)deleteObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inDatabase:^(FMDatabase *db) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [[dbModel class] deleteObjectSqlstatementWithFormat:[dbModel deleteObjectSqlstatement]];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                FFDBDLog(@"error");
            }
            
        }
    }];
}

+ (BOOL)deleteObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:[dbClass deleteObjectSqlstatementWithFormat:format]];
    }];
    return result;
}

@end
