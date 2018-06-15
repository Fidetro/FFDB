//
//  TestModel.m
//  FFDB
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (NSArray *)memoryPropertys
{
    return @[@"memory"];
}

+ (NSDictionary *)columnsType
{
    return @{@"time":@"double"};
}

+ (NSString *)primaryKeyColumn
{
    return @"testKey";
}

@end
