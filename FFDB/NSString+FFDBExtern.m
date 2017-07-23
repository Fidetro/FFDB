//
//  NSString+FFDBExtern.m
//  FFDB
//
//  Created by Fidetro on 2017/7/23.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "NSString+FFDBExtern.h"
#import "FFDataBaseModel+Custom.h"
@implementation NSString (FFDBExtern)
+ (NSString *)stringWithColumns:(NSArray <NSString *>*)columns
{
    NSMutableString *columnsString = [NSMutableString string];
    for (NSInteger index = 0; index < columns.count; index++)
    {
        NSString *column = columns[index];
        if (index == 0)
        {
            [columnsString appendString:column];
        }
        else
        {
            [columnsString appendFormat:@",%@",column];
        }
    }
    return [columnsString copy];
}

+ (NSString *)stringWithTableNameOfClasses:(NSArray <Class>*)Classes
{
    NSMutableString *classesString = [NSMutableString string];
    for (NSInteger index = 0; index < Classes.count; index++)
    {
        Class class = Classes[index];
        NSString *tableName = [class tableName];
        if (index == 0)
        {
            [classesString appendFormat:@"`%@`",tableName];
        }
        else
        {
            [classesString appendFormat:@",`%@`",tableName];
        }
    }
    return [classesString copy];
}
@end
