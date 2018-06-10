//
//  Delete.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Delete.h"

@implementation Delete
- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self) {
        if ([stmt length] == 0)
        {
            self.stmt = [NSString stringWithFormat:@"delete "];
        }else
        {
            self.stmt = [NSString stringWithFormat:@"delete %@ ",stmt];
        }
    }
    return self;
}

+ (Delete *(^)(NSString *))begin
{
    return ^(NSString *stmt)
    {
        
        return [[Delete alloc]initWithSTMT:stmt];
    };
}

- (From *(^)(id))from
{
    return ^(id param){
        if ([param isSubclassOfClass:[FFDataBaseModel class]]) {
            return [[From alloc]initWithSTMT:self.stmt table:param];
        }
        return [[From alloc]initWithSTMT:self.stmt format:param];
    };
}


@end
