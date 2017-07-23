//
//  FFDataBaseModel+Sqlite.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"
@implementation FFDataBaseModel (Sqlite)

+ (NSString *)createTableSqlstatement
{
    NSString *tableKey = [NSString string];
    NSArray *propertyNames = [[self class]columsOfSelf];
    
    for (NSInteger index = 0; index < [propertyNames count]; index++)
    {
        NSString *propertyname = propertyNames[index];
        NSString *columnType = [[self columnsType][propertyname]length] == 0 ? @"text":[self columnsType][propertyname];
        
        if (index == 0)
        {
            tableKey = [NSString stringWithFormat:@"%@%@ %@",tableKey,propertyname,columnType];
            
            continue;
        }
        else
        {
            tableKey = [NSString stringWithFormat:@"%@,%@ %@",tableKey,propertyname,columnType];
            
        }
    }
    NSString *sqlstatement = [NSString stringWithFormat:@"create table if  not exists `%@%@` (primaryID integer PRIMARY KEY AUTOINCREMENT,%@)",kDatabaseHeadname,NSStringFromClass([self class]),tableKey];
    return sqlstatement;
}





+ (NSString *)selectFromClassSQLStatementWithFormat:(NSString *)format
{
    NSString *sqlstatement = @"";
    if ([format length] != 0)
    {
        sqlstatement = [NSString stringWithFormat:@"select *from `%@` %@",[[self class] tableName],format];
    }else
    {
        sqlstatement = [NSString stringWithFormat:@"select *from `%@`",[[self class] tableName]];
    }
    return sqlstatement;
}



- (NSString *)insertFromClassSQLStatementWithColumns:(NSArray <NSString *>*)columns
{
    NSString *keys = [NSString string];
    NSString *values = [NSString string];
    
    for (NSInteger index = 0; index < [columns count]; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            keys = [NSString stringWithFormat:@"%@'%@'",keys,column];
            values = [NSString stringWithFormat:@"%@'%@'",values,[self getIvarWithName:column]];
            
        }
        else
        {
            keys = [NSString stringWithFormat:@"%@,'%@'",keys,column];
            values = [NSString stringWithFormat:@"%@,'%@'",values,[self getIvarWithName:column]];
        }
    }
    NSString *sqlstatement = [NSString stringWithFormat:@"insert into `%@` (%@) values(%@) ",[[self class] tableName],keys,values];
    return sqlstatement;
}

- (NSString *)updateFromClassSQLStatementWithColumns:(NSArray <NSString *>*)columns
{
    NSString *values = [NSString string];
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            values = [NSString stringWithFormat:@"%@%@='%@'",values,column,[self getIvarWithName:column]];
        }
        else
        {
            values = [NSString stringWithFormat:@"%@,%@='%@'",values,column,[self getIvarWithName:column]];
        }
    }
    NSString *sqlstatement = [NSString stringWithFormat:@"update `%@` set  %@ where primaryID = '%@'",[[self class] tableName],values,self.primaryID];
    return sqlstatement;
}

- (NSString *)deleteObjectSqlstatement
{
    return [NSString stringWithFormat:@"where primaryID = '%@'",self.primaryID];
}

+ (NSString *)deleteFromSQLStatementWithFormat:(NSString *)format
{
    if ([format length] == 0)
    {
        return [NSString stringWithFormat:@"delete from `%@`",[[self class] tableName]];
    }
    else
    {
        return [NSString stringWithFormat:@"delete from `%@` %@",[[self class] tableName],format];
    }
}

- (NSString *)stringWithInsertValueOfColumns:(NSArray <NSString *>*)columns
{
    NSMutableString *values = [NSMutableString string];
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            [values appendFormat:@"'%@'",[self getIvarWithName:column]];
            
        }
        else
        {
            [values appendFormat:@",'%@'",[self getIvarWithName:column]];
        }
    }
    return values;
}

- (NSString *)stringWithUpdateSetValueOfColumns:(NSArray <NSString *>*)columns
{
    NSMutableString *values = [NSMutableString string];
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            [values appendFormat:@"%@ = '%@'",column,[self getIvarWithName:column]];
        }
        else
        {
            [values appendFormat:@",%@ = '%@'",column,[self getIvarWithName:column]];
        }
    }
    return values;
}

- (id)getIvarWithName:(NSString *)propertyname
{
    id obj = [self sendGetMethodWithPropertyName:propertyname];
    
    if ([obj respondsToSelector:@selector(length)])
    {
        if ([obj length] == 0)
        {
            obj = @"";
        }
    }
    else if (obj == nil)
    {
        obj = @"";
    };
    return obj;
}

@end
