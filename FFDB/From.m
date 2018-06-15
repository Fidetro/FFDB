//
//  From.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "From.h"

@implementation From

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@from %@ ",stmt,format];
    }
    return self;
}

- (instancetype)initWithSTMT:(NSString *)stmt table:(Class)table
{
    self = [self initWithSTMT:stmt format:[table tableName]];
    if (self)
    {
        
    }
    return self;
}

- (Where *(^)(NSString *))where
{
    return ^(NSString *stmt){
        return [[Where alloc]initWithSTMT:self.stmt format:stmt];
    };
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
