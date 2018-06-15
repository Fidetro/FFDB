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
#import "FFDataBaseModel+Custom.h"
#import "FMDatabase+FFExtern.h"
#import "Insert.h"
#import "Select.h"
#import "Delete.h"
#import "Update.h"
#import "Alter.h"
#import "Create.h"
@implementation FFDBManager

+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns
              values:(NSArray <id>*)values
                  db:(FMDatabase *)db
{
    if ([columns count] == 0)
    {
        columns = [[model class]columnsOfSelf];
    }
    if ([values count] == 0)
    {
        NSMutableArray *muValues = [NSMutableArray array];
        for (NSString *column in columns)
        {
           id values = [model getIvarWithName:column];
            [muValues addObject:values];
        }
        values = [muValues copy];
    }
    __block BOOL _result = NO;
    
    Insert
    .begin(nil)
    .into([model class])
    .columns(columns)
    .values(@(columns.count))
    .endUpdate(values,db,^(BOOL result){
        _result = result;
    });
    
    return _result;
}

+ (BOOL)insertTable:(Class)table
            columns:(NSArray <NSString *>*)columns
            values:(NSArray <id>*)values
                db:(FMDatabase *)db
{
    __block BOOL _result = NO;
    
    Insert
    .begin(nil)
    .into(table)
    .columns(columns)
    .values(@(columns.count))
    .endUpdate(values,db,^(BOOL result){
        _result = result;
    });
    
    return _result;
}

+ (NSArray *)selectFromClass:(Class)dbClass
                     columns:(NSArray <NSString *>*)columns
                       where:(NSString *)whereFormat
                      values:(NSArray <id>*)values
                     toClass:(Class)toClass
                          db:(FMDatabase *)db
{
    __block NSArray *_result = nil;
    if ([whereFormat length] == 0)
    {
        Select
        .begin([columns count] == 0 ? @"*":columns)
        .from(dbClass)
        .endQuery(values,toClass==nil?dbClass:toClass,db,^(NSArray *result){
            _result = result;
        });
    }else
    {
        Select
        .begin([columns count] == 0 ? @"*":columns)
        .from(dbClass)
        .where(whereFormat)
        .endQuery(values,toClass==nil?dbClass:toClass,db,^(NSArray *result){
            _result = result;
        });
    }
    
    return _result;
}





+ (BOOL)deleteFromClass:(Class)dbClass
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                     db:(FMDatabase *)db
{
    __block BOOL _result = NO;

    if ([whereFormat length] == 0)
    {
        Delete
        .begin(nil)
        .from(dbClass)
        .where(whereFormat)
        .endUpdate(values,db,^(BOOL result){
            _result = result;
        });
    }else
    {
        Delete
        .begin(nil)
        .from(dbClass)        
        .endUpdate(values,db,^(BOOL result){
            _result = result;
        });
    }

    
    return _result;
}



+ (BOOL)updateFromClass:(Class)dbClass
                    set:(NSArray <NSString *>*)setColumns
                  where:(NSString *)whereFormat
                 values:(NSArray <id>*)values
                     db:(FMDatabase *)db
{
    __block BOOL _result = NO;
    Update
    .begin(dbClass)
    .set(setColumns)
    .where(whereFormat)
    .endUpdate(values,db,^(BOOL result){
        _result = result;
    });
    
    return _result;

}

+ (void)alterFromClass:(Class)dbClass
{
    NSArray *newColumns = [self findNewColumns:dbClass];
    __block BOOL _result = NO;
    for (NSString *newColumn in newColumns)
    {
        Alter
        .begin(dbClass)
        .add(newColumn,dbClass)
        .endUpdate(nil,nil,^(BOOL result){
            _result = result;
        });
    }
}

+ (NSArray <NSString *>*)findNewColumns:(Class)dbClass
{
    NSString *tableName = [dbClass tableName];
    NSMutableArray *newColumns = [NSMutableArray array];
    for (NSString *column in [dbClass columnsOfSelf])
    {
        BOOL result = [self columnExists:column inTableWithName:tableName];
        if (result == NO)
        {
            [newColumns addObject:column];
        }
    }
    return  [newColumns copy];
}

+ (BOOL)columnExists:(NSString *)column inTableWithName:(NSString *)tableName
{
    FMDatabase *database = [self database];
    BOOL result = NO;
    if ([database open])
    {
        result = [database columnExists:column inTableWithName:tableName];
    }
    return result;
}

+ (BOOL)createTableFromClass:(Class)dbClass
{
    __block BOOL _result = NO;

    Create
    .begin(dbClass)
    .endUpdate(nil,nil,^(BOOL result){
        _result = result;
    });
    
    return _result;
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
