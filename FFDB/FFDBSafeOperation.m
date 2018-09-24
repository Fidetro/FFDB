//
//  FFDBSafeOperation.m
//  FFDB
//
//  Created by Fidetro on 2017/5/15.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDBSafeOperation.h"
#import "FFDBLog.h"
#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"

@implementation FFDBSafeOperation

+ (void)selectAllObjectFromClass:(Class)dbClass
                      completion:(QueryResult)block
{
    [self excuteDBQuery:^(FMDatabase *db) {
       NSArray *objectList = [FFDBManager selectFromClass:dbClass columns:nil where:nil values:nil toClass:dbClass db:db];
        if (block) {
            block(objectList);
        }
    }];
}


+ (void)selectFromClass:(Class)dbClass
                columns:(NSArray <NSString *>*)columns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                toClass:(Class)toClass
             completion:(QueryResult)block
{
    [self excuteDBQuery:^(FMDatabase *db) {
        NSArray *objectList = [FFDBManager selectFromClass:dbClass columns:columns where:whereFormat values:values toClass:toClass db:db];
        if (block) {
            block(objectList);
        }
    }];
}

+ (void)insertObjectList:(NSArray <__kindof FFDataBaseModel *>*)objectList
              completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        for (FFDataBaseModel *model in objectList)
        {
            BOOL result = [model insertObject:db];
            if (block)
            {
                block(result);
            }
        }
    }];
}

+ (void)insertTable:(Class)table
            columns:(NSArray <NSString *>*)columns
             values:(NSArray <id>*)values
         completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        BOOL result = [FFDBManager insertTable:table columns:columns values:values db:db];
        if (block) {
            block(result);
        }
    }];
}

+ (void)updateObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        for (FFDataBaseModel *model in objectList)
        {
            BOOL result = [model updateObject:db];
            if (block) {
                block(result);
            }
        }
    }];
}

+ (void)updateFromClass:(Class)dbClass
                    set:(NSArray <NSString *>*)setColumns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        BOOL result = [FFDBManager updateFromClass:dbClass set:setColumns where:whereFormat values:values db:db];
        if (block) {
            block(result);
        }
    }];
}

+ (void)deleteObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        for (FFDataBaseModel *model in objectList)
        {
            [model deleteObject:db];
        }
        if (block)
        {
            block(YES);
        }
    }];
}

+ (void)deleteFromClass:(Class)dbClass
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db) {
        BOOL result = [FFDBManager deleteFromClass:dbClass where:whereFormat values:values db:db];
        if (block)
        {
            block(result);
        }
    }];
}

+ (void)excuteDBQuery:(void(^)(FMDatabase *db))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inDatabase:block];
}

+ (void)excuteDBUpdate:(void(^)(FMDatabase *db))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inDatabase:block];
}

@end
