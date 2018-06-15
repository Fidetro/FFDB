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

+ (NSString *)primaryKeyColumn
{
    return @"primaryKeyColumn";
}



@end
