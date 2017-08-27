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
    return @{@"_id":@"id"};
}

+ (NSDictionary *)columnsType
{
    return @{@"id":@"integer"};
}

+ (NSArray *)memoryPropertys
{
    return @[@"mem"];
}

@end
