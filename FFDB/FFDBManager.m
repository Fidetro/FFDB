//
//  FFDBManager.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDBManager.h"
#import "FFDataBaseModel+Sqlite.h"
#import "NSObject+FIDProperty.h"
#import "NSString+FFDBSQLStatement.h"
#import "FFDataBaseModel+Custom.h"
#import "FMDatabase+FFExtern.h"

@implementation FFDBManager

+ (NSArray *)selectColumns:(NSArray <NSString *>*)columns
                 fromClass:(Class)dbClass
    SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    NSArray *dataColumns = [NSArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    if (columns.count == 0)
    {
        dataColumns = [dbClass columnsOfSelf];
    }
    else
    {
        dataColumns = columns;
    }
    if ([database open])
    {
        FMResultSet *resultSet;
        resultSet = [database executeQuery:[NSString stringWithSelectColumns:columns fromClasses:@[dbClass] SQLStatementWithFormat:format]];
        while ([resultSet next])
        {
            id object = [[dbClass alloc]init];
            for (NSString *propertyname in dataColumns)
            {
                NSString *result = [resultSet stringForColumn:propertyname];
                NSString *objStr = [result length] == 0 ? @"" :result;
                [object setPropertyWithName:propertyname object:objStr];
            }
            [object setPropertyWithName:@"primaryID" object:[resultSet stringForColumn:@"primaryID"]];
            [dataArray addObject:object];
        }
        
    }
    
    [database close];
    return dataArray;
}

+ (NSArray <__kindof FFDataBaseModel *>*)selectColumns:(NSArray <NSString *>*)columns
                                           fromClasses:(NSArray<Class> *)dbClasses
                                               toClass:(Class)toClass
                                SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    NSMutableArray *dataColumns = [NSMutableArray array];
    NSMutableArray *dataArray = [NSMutableArray array];
    if (columns.count == 0)
    {
        for (Class dbClass in dbClasses)
        {
            [dataColumns addObjectsFromArray:[dbClass columnsOfSelf]];
        }
    }
    else
    {
        dataColumns = [columns copy];
    }
    if ([database open])
    {
        FMResultSet *resultSet;
        resultSet = [database executeQuery:[NSString stringWithSelectColumns:columns fromClasses:dbClasses SQLStatementWithFormat:format]];
        while ([resultSet next])
        {
            id object = [[toClass alloc]init];
            for (NSString *propertyname in dataColumns)
            {
                NSString *result = [resultSet stringForColumn:propertyname];
                NSString *objStr = [result length] == 0 ? @"" :result;
                [object setPropertyWithName:propertyname object:objStr];
            }
            [object setPropertyWithName:@"primaryID" object:[resultSet stringForColumn:@"primaryID"]];
            [dataArray addObject:object];
        }
        
    }
    
    [database close];
    return dataArray;
}

+ (BOOL)deleteFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatementAfterClose:[NSString stringWithDeleteFromClass:dbClass SQLStatementWithFormat:format]];
}

+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatementAfterClose:[NSString stringWithInsertObject:model columns:columns]];
}

+ (BOOL)updateFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatementAfterClose:[NSString stringWithUpdateFromClass:dbClass SQLStatementWithFormat:format]];
}

+ (BOOL)updateObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatementAfterClose:[NSString stringWithUpdateObject:model columns:columns]];
}

+ (void)alertFromClass:(Class)dbClass
               columns:(NSArray <NSString *>*)columns
{
    FMDatabase *database = [self database];
    NSString *tableName = [dbClass tableName];
    if (columns.count == 0)
    {
        columns = [dbClass columnsOfSelf];
    }
    
    if ([database open])
    {
        
        for (NSString *propertyname in columns)
        {
            if (![database columnExists:propertyname inTableWithName:tableName])
            {
                [database executeUpdateWithSqlstatement:[NSString stringWithFormat:@"alter table `%@` add %@ text",tableName,propertyname]];
            }
        }
    }
    [database close];
}

+ (BOOL)createTableFromClass:(Class)dbClass
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatementAfterClose:[NSString stringWithCreateTableFromClass:dbClass]];
    
}

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



@end
