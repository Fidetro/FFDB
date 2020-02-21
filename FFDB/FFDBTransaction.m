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

@implementation FFDBTransaction

+ (void)selectAllObjectFromClass:(Class)dbClass
                      completion:(QueryResult)block
{
    [self excuteDBQuery:^(FMDatabase *db,BOOL *rollback) {
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
    [self excuteDBQuery:^(FMDatabase *db,BOOL *rollback) {
        NSArray *objectList = [FFDBManager selectFromClass:dbClass columns:columns where:whereFormat values:values toClass:toClass db:db];
        if (block)
        {
            block(objectList);
        }
    }];
}

+ (void)insertObjectList:(NSArray <__kindof FFDataBaseModel *>*)objectList
              isRollBack:(BOOL)isRollBack
              completion:(UpdateListResult)block

{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        for (int i = 0; i < objectList.count; i++)
        {
            @autoreleasepool
            {
                FFDataBaseModel *model = objectList[i];
                BOOL result = [model insertObject:db];
                if (result == NO)
                {
                    *rollback = isRollBack;
                    FFDBDLog(@"error rollback");
                }
                if (block)
                {
                    block(result,(objectList.count-1) == i ? YES:NO);
                }
            }
        }
    }];
}

+ (void)insertTable:(Class)table
            columns:(NSArray <NSString *>*)columns
             values:(NSArray <id>*)values
         isRollBack:(BOOL)isRollBack
         completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        BOOL result = [FFDBManager insertTable:table columns:columns values:values db:db];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
        if (block) {
            block(result);
        }
    }];
}

+ (void)updateObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              isRollBack:(BOOL)isRollBack
              completion:(UpdateListResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        for (int i = 0; i < objectList.count; i++)
        {
            @autoreleasepool
            {
                FFDataBaseModel *model = objectList[i];
                BOOL result = [model updateObject:db];
                if (result == NO)
                {
                    *rollback = isRollBack;
                    FFDBDLog(@"error rollback");
                }
                if (block)
                {
                    block(result,(objectList.count-1) == i ? YES:NO);
                }
            }
        }
    }];
}

+ (void)updateFromClass:(Class)dbClass
                    set:(NSArray <NSString *>*)setColumns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             isRollBack:(BOOL)isRollBack
             completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        BOOL result = [FFDBManager updateFromClass:dbClass set:setColumns where:whereFormat values:values db:db];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
        if (block)
        {
            block(result);
        }
    }];
}

+ (void)deleteObjectList:(NSArray<__kindof FFDataBaseModel *> *)objectList
              isRollBack:(BOOL)isRollBack
              completion:(UpdateListResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        for (int i = 0; i < objectList.count; i++)
        {
            @autoreleasepool
            {
                FFDataBaseModel *model = objectList[i];
                BOOL result = [model deleteObject:db];
                if (result == NO)
                {
                    *rollback = isRollBack;
                    FFDBDLog(@"error rollback");
                }
                if (block)
                {
                    block(result,(objectList.count-1) == i ? YES:NO);
                }
            }
        }
    }];
}

+ (void)deleteFromClass:(Class)dbClass
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
             isRollBack:(BOOL)isRollBack
             completion:(UpdateResult)block
{
    [self excuteDBUpdate:^(FMDatabase *db,BOOL *rollback) {
        BOOL result = [FFDBManager deleteFromClass:dbClass where:whereFormat values:values db:db];
        if (result == NO)
        {
            *rollback = isRollBack;
            FFDBDLog(@"error rollback");
        }
        if (block)
        {
            block(result);
        }
    }];
}



+ (void)excuteDBQuery:(void(^)(FMDatabase *db,BOOL *rollback))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:block];
}

+ (void)excuteDBUpdate:(void(^)(FMDatabase *db,BOOL *rollback))block
{
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:[FFDBManager databasePath]];
    [queue inTransaction:block];
}

@end
