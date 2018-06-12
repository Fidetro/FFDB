//
//  Into.m
//  FFDB
//
//  Created by Fidetro on 2018/6/8.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Into.h"

@implementation Into

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@into %@ ",stmt,format];
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

- (Columns *(^)(id))columns
{
    return ^(id param){
        if ([param isKindOfClass:[NSArray class]]) {
            return [[Columns alloc]initWithSTMT:self.stmt columns:param];
        }
        return [[Columns alloc]initWithSTMT:self.stmt format:param];
    };
}

@end
