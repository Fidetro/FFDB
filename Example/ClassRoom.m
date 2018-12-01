//
//  Classroom.m
//  FFDB
//
//  Created by Fidetro on 2017/3/26.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "ClassRoom.h"

@implementation ClassRoom

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.name = @"new room";
    }
    return self;
}

//从4.x后版本，必须重写该方法，指定主键字段
+ (NSString *)primaryKeyColumn
{
    return @"primaryKeyColumn";
}
//从4.x后版本，如需主键自增，还需要自行设置字段属性
+ (NSDictionary *)columnsType
{
    return @{@"primaryKeyColumn":@"integer PRIMARY KEY AUTOINCREMENT"};
}



@end
