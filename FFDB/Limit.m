//
//  Limit.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Limit.h"

@implementation Limit
- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@limit %@ ",stmt,format];
    }
    return self;
}

- (Offset *(^)(NSString *))offset
{
    return ^(NSString *stmt){
        return [[Offset alloc]initWithSTMT:self.stmt format:stmt];
    };
}

@end
