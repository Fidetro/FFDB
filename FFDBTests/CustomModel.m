//
//  CustomModel.m
//  FFDBTests
//
//  Created by Fidetro on 2017/8/27.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "CustomModel.h"

@implementation CustomModel

+ (NSDictionary *)customColumns
{
    return @{@"_id":@"id",
             @"_name":@"name"};
}

+ (NSString *)tableName
{
    return @"Custom";
}

+ (NSDictionary *)columnsType
{
    return @{@"id":@"integer",@"testData":@"blob"};
}

+ (NSArray *)memoryPropertys
{
    return @[@"mem"];
}

+ (NSString *)primaryKeyColumn
{
    return @"coustomKey";
}


@end
