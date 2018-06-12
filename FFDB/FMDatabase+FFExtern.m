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
            for (NSString *propertyname in resultSet.resultDictionary)
            {
                NSString *result = [resultSet stringForColumn:propertyname];
                NSString *objStr = [result length] == 0 ? @"" :result;
                [object setPropertyWithName:propertyname object:objStr];
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

@end
