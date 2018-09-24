//
//  FMDatabase+FFExtern.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FMDatabase+FFExtern.h"
#import "FFDBLog.h"
#import "NSObject+FIDProperty.h"
#import "FFDataBaseModel+Custom.h"
@implementation FMDatabase (FFExtern)

- (void)executeUpdateWithSqlstatement:(NSString *)sqlstatement
                               values:(NSArray <id>*)values
                           completion:(UpdateResult)block
{
    BOOL result = NO;
    if ([self open])
    {
        NSError *error;
        result =  [self executeUpdate:sqlstatement values:values error:&error];
        if (error)
        {
            FFDBDLog("%@",error);
        }
    }
    if (block) {
        block(result);
    }
    
}

- (void)executeQueryWithSqlstatement:(NSString *)sqlstatement
                              values:(NSArray <id>*)values
                             toClass:(Class)toClass
                          completion:(QueryResult)block
{
    NSMutableArray *dataArray = [NSMutableArray array];
    if ([self open])
    {
        NSError *error;
        FMResultSet *resultSet;
        resultSet =  [self executeQuery:sqlstatement values:values error:&error];
        while ([resultSet next])
        {
            id object = [[toClass alloc]init];
//            NSDictionary *types = [[object class] propertysType];
            for (NSString *propertyname in [[object class] propertyOfSelf])
            {
                NSString *customColumns = [[object class] customColumns][propertyname];
                if ([customColumns length] == 0)
                {
                    id value = resultSet.resultDictionary[propertyname];
                    value = [self covertToPropertyValue:value];
                    [object setPropertyWithName:propertyname object:value];
                }else
                {
                    id value = resultSet.resultDictionary[customColumns];
                    value = [self covertToPropertyValue:value];
                    [object setPropertyWithName:customColumns object:value];
                }
            }
            [dataArray addObject:object];
        }
        if (error)
        {
            FFDBDLog("%@",error);
        }
    }
    if (block)
    {
        block(dataArray);
    }
}

- (id)covertToPropertyValue:(id)value
{
    if ([value isKindOfClass:[NSNumber class]])
    {
        value = [NSString stringWithFormat:@"%@",value];
    }else if ([value isKindOfClass:[NSNull class]])
    {
        value = @"";
    }
    return value;
}

@end
