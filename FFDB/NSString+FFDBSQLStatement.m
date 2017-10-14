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

+ (NSString *)stringWithSelectCountfromClasses:(NSArray <Class>*)dbClasses
                        SQLStatementWithFormat:(NSString *)format
{
    NSMutableString *sqlstatement = [NSMutableString string];
    [sqlstatement appendString:@"select count(*) from "];
    [sqlstatement appendString:[NSString stringWithTableNameOfClasses:dbClasses]];
    
    if ([format length] != 0)
    {
        [sqlstatement appendFormat:@" %@",format];
    }
    
    return [sqlstatement copy];
}
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


+ (NSString *)stringWithInsertObject:(__kindof FFDataBaseModel *)dbModel
                            columns:(NSArray <NSString *>*)columns
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [[dbModel class] tableName];
    if (columns.count == 0)
    {
        columns = [[dbModel class]columnsOfSelf];
    }
    NSString *columnsString = [NSString stringWithColumns:columns];
    
    
    [sqlstatement appendFormat:@"insert into `%@` ",tableName];
    [sqlstatement appendFormat:@"(%@)",columnsString];
    [sqlstatement appendFormat:@"values(%@)",[dbModel stringWithInsertValueOfColumns:columns]];
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

+ (NSString *)stringWithUpdateObject:(__kindof FFDataBaseModel *)dbModel
                             columns:(NSArray <NSString *>*)columns
{
    NSMutableString *sqlstatement = [NSMutableString string];
    NSString *tableName = [[dbModel class] tableName];
    if (columns.count == 0)
    {
        columns = [[dbModel class]columnsOfSelf];
    }
    [sqlstatement appendFormat:@"update `%@` ",tableName];
    [sqlstatement appendFormat:@"set %@",[dbModel stringWithUpdateSetValueOfColumns:columns]];
    [sqlstatement appendString:[dbModel updateObjectSqlstatement]];
    return [sqlstatement copy];
}

+ (NSString *)stringWithCreateTableFromClass:(Class)dbClass
{
    NSString *tableKey = [NSString string];
    NSArray *propertyNames = [dbClass columnsOfSelf];
    NSString *tableName = [dbClass tableName];
    tableKey = [dbClass stringToColumnTypeWithColumns:propertyNames];
//    for (NSInteger index = 0; index < [propertyNames count]; index++)
//    {
//        NSString *propertyname = propertyNames[index];
//        NSString *columnType = [[dbClass columnsType][propertyname]length] == 0 ? @"text":[dbClass columnsType][propertyname];
//
//        if (index == 0)
//        {
//            tableKey = [NSString stringWithFormat:@"%@%@ %@",tableKey,propertyname,columnType];
//        }
//        else
//        {
//            tableKey = [NSString stringWithFormat:@"%@,%@ %@",tableKey,propertyname,columnType];
//        }
//    }
    NSString *sqlstatement = [NSString stringWithFormat:@"create table if  not exists `%@` (primaryID integer PRIMARY KEY AUTOINCREMENT,%@)",tableName,tableKey];
    return sqlstatement;
}

@end
