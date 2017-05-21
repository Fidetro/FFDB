//
//  FFDataBaseModel+Sqlite.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel+Sqlite.h"

@implementation FFDataBaseModel (Sqlite)

+ (NSString *)createTableSqlstatement
{
    NSString *tableKey = [NSString string];
    NSArray *propertyNames = [[self class]propertyOfSelf];
    for (NSInteger index = 0; index < [propertyNames count]; index++)
    {
        NSString *propertyname = propertyNames[index];
        if (index == 0)
        {
            tableKey = [NSString stringWithFormat:@"%@%@ text",tableKey,propertyname];
            continue;
        }
        tableKey = [NSString stringWithFormat:@"%@,%@ text",tableKey,propertyname];
    }
    NSString *sqlstatement = [NSString stringWithFormat:@"create table if  not exists `%@%@` (primaryID integer PRIMARY KEY AUTOINCREMENT,%@)",kDatabaseHeadname,NSStringFromClass([self class]),tableKey];
    return sqlstatement;
}

+ (NSString *)selectObjectSqlstatementWithFormat:(NSString *)format
{
    NSString *sqlstatement = @"";
    if ([format length] != 0)
    {
        sqlstatement = [NSString stringWithFormat:@"select *from `%@` %@",[[self class] getTableName],format];
    }else
    {
        sqlstatement = [NSString stringWithFormat:@"select *from `%@`",[[self class] getTableName]];
    }
    return sqlstatement;
}


- (NSString *)insertObjectSqlstatement
{
    NSString *keys = [NSString string];
    NSString *values = [NSString string];
    NSArray *propertyNames = [[self class]propertyOfSelf];
    for (NSInteger index = 0; index < [propertyNames count]; index++)
    {
        NSString *propertyname = propertyNames[index];
        if (index == 0)
        {
            keys = [NSString stringWithFormat:@"%@'%@'",keys,propertyname];
            values = [NSString stringWithFormat:@"%@'%@'",values,[self getIvarWithName:propertyname]];
            
        }
        else
        {
            keys = [NSString stringWithFormat:@"%@,'%@'",keys,propertyname];
            values = [NSString stringWithFormat:@"%@,'%@'",values,[self getIvarWithName:propertyname]];
        }
    }
    NSString *sqlstatement = [NSString stringWithFormat:@"insert into `%@` (%@) values(%@) ",[[self class] getTableName],keys,values];
    return sqlstatement;
}

- (NSString *)updateObjectSqlStatementWithColumns:(NSArray <NSString *>*)columns
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
    NSString *sqlstatement = [NSString stringWithFormat:@"update `%@` set  %@ where primaryID = '%@'",[[self class] getTableName],values,self.primaryID];
    return sqlstatement;
}

- (NSString *)deleteObjectSqlstatement
{
    return [NSString stringWithFormat:@"where primaryID = '%@'",self.primaryID];
}

+ (NSString *)deleteObjectSqlstatementWithFormat:(NSString *)format
{
    if ([format length] == 0)
    {
        return [NSString stringWithFormat:@"delete from `%@`",[[self class] getTableName]];
    }
    else
    {
        return [NSString stringWithFormat:@"delete from `%@` %@",[[self class] getTableName],format];
    }
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
