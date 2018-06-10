//
//  Where.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Where.h"

@implementation Where

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@where %@ ",stmt,format];
    }
    return self;
}

- (OrderBy *(^)(NSString *))orderBy
{
    return ^(NSString *stmt){
        return [[OrderBy alloc]initWithSTMT:self.stmt format:stmt];
    };
}

- (Limit *(^)(NSString *))limit
{
    return ^(NSString *stmt){
        return [[Limit alloc]initWithSTMT:self.stmt format:stmt];
    };
}

- (Offset *(^)(NSString *))offset
{
    return ^(NSString *stmt){
        return [[Offset alloc]initWithSTMT:self.stmt format:stmt];
    };
}

@end
