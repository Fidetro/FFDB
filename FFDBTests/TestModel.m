//
//  TestModel.m
//  FFDB
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "TestModel.h"

@implementation TestModel

+ (NSArray *)memoryColumns
{
    return @[@"memory"];
}

+ (NSDictionary *)columnsType
{
    return @{@"time":@"double"};
}

@end
