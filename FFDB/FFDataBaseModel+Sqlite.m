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

- (NSString *)deleteObjectSqlstatement
{
    return [NSString stringWithFormat:@"where primaryID = '%@'",self.primaryID];
}

- (NSString *)updateObjectSqlstatement
{
    return [NSString stringWithFormat:@"where primaryID = '%@'",self.primaryID];
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

- (NSString *)stringWithWhereValueOfColumns:(NSArray <NSString *>*)columns
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

+ (NSString *)stringToColumnTypeWithColumns:(NSArray <NSString *>*)columns
{
    NSMutableString *columnsType = [NSMutableString string];
    
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *propertyname = columns[index];
        NSString *columnType = [[self columnsType][propertyname]length] == 0 ? @"text":[self columnsType][propertyname];
        
        if (index == 0)
        {
            [columnsType appendFormat:@"%@ %@",propertyname,columnType];
            
        }
        else
        {
            [columnsType appendFormat:@",%@ %@",propertyname,columnType];
        }
    }
    return columnsType;
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
    if ([obj isKindOfClass:[NSString class]])
    {
        NSString *str = obj;
        [str stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
        [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        [str stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
        [str stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
        [str stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
        [str stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
        [str stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
        [str stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
        [str stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    }
    return obj;
}

@end
