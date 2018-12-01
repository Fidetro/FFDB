//
//  FFStore.m
//  FFDB
//
//  Created by Fidetro on 2017/10/14.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFStore.h"

@implementation FFStore


//从4.x后版本，必须重写该方法，指定主键字段
+ (NSString *)primaryKeyColumn
{
    return @"storePrimaryKeyColumn";
}
//从4.x后版本，如需主键自增，还需要自行设置字段属性
+ (NSDictionary *)columnsType
{
    return @{@"storePrimaryKeyColumn":@"integer PRIMARY KEY AUTOINCREMENT"};
}


@end
