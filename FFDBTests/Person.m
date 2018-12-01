//
//  Person.m
//  FFDBTests
//
//  Created by Fidetro on 2018/12/1.
//  Copyright © 2018 Fidetro. All rights reserved.
//

#import "Person.h"

@implementation Person
//从4.x后版本，必须重写该方法，指定主键字段
+ (NSString *)primaryKeyColumn
{
    return @"priamryID";
}
//从4.x后版本，如需主键自增，还需要自行设置字段属性
+ (NSDictionary *)columnsType
{
    return @{@"priamryID":@"integer PRIMARY KEY AUTOINCREMENT"};
}

@end
