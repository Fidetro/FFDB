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

@implementation FFDBManager

+ (NSArray *)selectColumns:(NSArray <NSString *>*)columns
                 fromClass:(Class)dbClass
    SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    NSMutableArray *dataArray = [NSMutableArray array];
    
    if ([database open])
    {;
        FMResultSet *resultSet;
        resultSet = [database executeQuery:[NSString stringWithSelectColumns:columns fromClasses:@[dbClass] SQLStatementWithFormat:format]];
        while ([resultSet next])
        {
            
            id object = [[dbClass alloc]init];
            for (NSString *propertyname in columns)
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
    return [database executeUpdateWithSqlstatement:[NSString stringWithDeleteFromClass:dbClass SQLStatementWithFormat:format]];
}

+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatement:[NSString stringWithInsertObject:model columns:columns]];
}

+ (BOOL)updateFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatement:[NSString stringWithUpdateFromClass:dbClass SQLStatementWithFormat:format]];
}

+ (BOOL)updateObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
{
    FMDatabase *database = [self database];
    return [database executeUpdateWithSqlstatement:[NSString stringWithUpdateObject:model columns:columns]];
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
