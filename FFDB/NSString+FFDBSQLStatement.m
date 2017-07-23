//
//  NSString+FFDBSQLStatement.m
//  FFDB
//
//  Created by Fidetro on 2017/7/23.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "NSString+FFDBSQLStatement.h"
#import "NSString+FFDBExtern.h"
#import "FFDataBaseModel+Custom.h"
#import "FFDataBaseModel+Sqlite.h"
@implementation NSString (FFDBSQLStatement)

+ (NSString *)stringWithSelectColumns:(NSArray <NSString *>*)columns
                          fromClasses:(NSArray <Class>*)dbClasses
               SQLStatementWithFormat:(NSString *)format
{
    NSMutableString *sqlstatement = [NSMutableString string];
    if (columns.count == 0)
    {
        [sqlstatement appendString:@"select * from "];
    }
    else
    {
        [sqlstatement appendFormat:@"select %@ from ",[NSString stringWithColumns:columns]];
    }
    [sqlstatement appendString:[NSString stringWithTableNameOfClasses:dbClasses]];
    
    if ([format length] != 0)
    {
        [sqlstatement appendFormat:@" %@",format];
    }
    
    return [sqlstatement copy];
}

+ (NSString *)stringWithDeleteFromClass:(Class)dbClass
                 SQLStatementWithFormat:(NSString *)format
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [dbClass tableName];
    [sqlstatement appendFormat:@"delete from `%@` ",tableName];
    if ([format length] != 0)
    {
        [sqlstatement appendString:format];
    }
    return [sqlstatement copy];
}


+ (NSString *)stringWithInsertObject:(__kindof FFDataBaseModel *)model
                            columns:(NSArray <NSString *>*)columns
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [[model class] tableName];
    NSString *columnsString = [NSString stringWithColumns:columns];
    if (columns.count == 0)
    {
        columns = [[model class]columsOfSelf];
    }
    
    [sqlstatement appendFormat:@"insert into `%@` ",tableName];
    [sqlstatement appendFormat:@"(%@)",columnsString];
    [sqlstatement appendFormat:@"values(%@)",[model stringWithInsertValueOfColumns:columns]];
    return [sqlstatement copy];
}

+ (NSString *)stringWithUpdateFromClass:(Class)dbClass
                 SQLStatementWithFormat:(NSString *)format
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [dbClass tableName];
    [sqlstatement appendFormat:@"update `%@` %@",tableName,format];
    return [sqlstatement copy];
}

+ (NSString *)stringWithUpdateObject:(__kindof FFDataBaseModel *)model
                             columns:(NSArray <NSString *>*)columns
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [[model class] tableName];
    if (columns.count == 0)
    {
        columns = [[model class]columsOfSelf];
    }
    [sqlstatement appendFormat:@"update `%@` ",tableName];
    [sqlstatement appendFormat:@"set %@",[model stringWithUpdateSetValueOfColumns:columns]];
    [sqlstatement appendFormat:@"where primaryID = '%@'",model.primaryID];
    return [sqlstatement copy];
}

@end
