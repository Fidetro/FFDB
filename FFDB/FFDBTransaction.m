//
//  FFDBTransaction.m
//  FFDB
//
//  Created by Fidetro on 2017/5/12.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDBTransaction.h"
#import "FFDBLog.h"
@implementation FFDBTransaction

+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass
{
    return [FFDBTransaction selectObjectWithFFDBClass:dbClass format:nil];
}

+ (NSArray *)selectObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    NSMutableArray *objectList = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
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
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [dbModel insertObjectSqlstatement];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = YES;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (void)updateObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [dbModel updateObjectSqlStatementWithColumns:[[dbModel class]propertyOfSelf]];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = YES;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (BOOL)updateObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[NSString stringWithFormat:@"update `%@` %@",[dbClass getTableName],format]];
    }];
    return result;
}

+ (void)deleteObjectList:(NSArray<FFDataBaseModel *> *)objectList
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [[dbModel class] deleteObjectSqlstatementWithFormat:[dbModel deleteObjectSqlstatement]];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = YES;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (BOOL)deleteObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[dbClass deleteObjectSqlstatementWithFormat:format]];
    }];
    return result;
}


@end
