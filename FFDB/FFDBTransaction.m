//
//  FFDBTransaction.m
//  FFDB
//
//  Created by Fidetro on 2017/5/12.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDBTransaction.h"
#import "FFDBLog.h"
#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"
#import "NSString+FFDBSQLStatement.h"
@implementation FFDBTransaction

+ (NSArray <__kindof FFDataBaseModel *>*)selectObjectWithFFDBClass:(Class)dbClass
{
    return [FFDBTransaction selectObjectWithFFDBClass:dbClass format:nil];
}

+ (NSArray <__kindof FFDataBaseModel *>*)selectObjectWithFFDBClass:(Class)dbClass format:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    NSMutableArray *objectList = [NSMutableArray array];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet;
        resultSet = [db executeQuery:[NSString stringWithSelectColumns:nil fromClasses:@[dbClass] SQLStatementWithFormat:format]];
        while ([resultSet next])
        {
            
            id object = [[dbClass alloc]init];
            for (NSString *propertyname in [dbClass columnsOfSelf])
            {
                NSString *result = [resultSet stringForColumn:propertyname];
                NSString *objStr = [result length] == 0 ? @"" :result;
                [object setPropertyWithName:propertyname object:objStr];
            }
            [object setPropertyWithName:@"primaryID" object:[resultSet stringForColumn:@"primaryID"]];
            [objectList addObject:object];
        }
    }];
    return [objectList copy];
}

+ (void)insertObjectList:(NSArray <__kindof FFDataBaseModel *>*)objectList
              isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [NSString stringWithInsertObject:dbModel columns:nil];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = isRollBack;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (void)updateObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [NSString stringWithUpdateObject:dbModel columns:nil];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = isRollBack;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (BOOL)updateObjectWithFFDBClass:(Class)dbClass
                           format:(NSString *)format
                       isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[NSString stringWithUpdateFromClass:dbClass SQLStatementWithFormat:format]];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
    }];
    return result;
}

+ (void)deleteObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        for (FFDataBaseModel *dbModel in objectList)
        {
            NSString *sql = [NSString stringWithDeleteFromClass:[dbModel class] SQLStatementWithFormat:[dbModel deleteObjectSqlstatement]];
            BOOL result = [db executeUpdate:sql];
            if (result == NO)
            {
                *rollback = isRollBack;
                FFDBDLog(@"error rollback");
            }
            
        }
    }];
}

+ (BOOL)deleteObjectWithFFDBClass:(Class)dbClass
                           format:(NSString *)format
                       isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:[NSString stringWithDeleteFromClass:dbClass SQLStatementWithFormat:format]];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
    }];
    return result;
}


+ (NSArray <__kindof FFDataBaseModel *>*)selectDBToClass:(Class)toClass
                                  SQLStatementWithFormat:(NSString *)format
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    NSMutableArray *objectList = [NSMutableArray array];
    NSArray *dataColumns = [toClass columnsOfSelf];

    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        FMResultSet *resultSet;
        resultSet = [db executeQuery:format];
        while ([resultSet next])
        {
            
            id object = [[toClass alloc]init];
            for (NSString *propertyname in dataColumns)
            {
                NSString *result = [resultSet stringForColumn:propertyname];
                NSString *objStr = [result length] == 0 ? @"" :result;
                [object setPropertyWithName:propertyname object:objStr];
            }
            [objectList addObject:object];
        }
    }];
    return [objectList copy];
}

+ (BOOL)updateDBWithSQLStatementWithFormat:(NSString *)format
                                isRollBack:(BOOL)isRollBack
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    __block BOOL result = NO;
    [queue inTransaction:^(FMDatabase *db, BOOL *rollback) {
        result = [db executeUpdate:format];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
    }];
    return result;
}

@end
