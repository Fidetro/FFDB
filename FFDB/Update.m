//
//  Update.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Update.h"

@implementation Update

- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self) {
        if ([stmt length] == 0)
        {
            self.stmt = [NSString stringWithFormat:@"update "];
        }else
        {
            self.stmt = [NSString stringWithFormat:@"update %@ ",stmt];
        }
    }
    return self;
}

- (instancetype)initWithTable:(Class)table
{
    self = [self initWithSTMT:[table tableName]];
    if (self)
    {
        
    }
    return self;
}

+ (Update *(^)(id))begin
{
    return ^(id param){
        if ([param isKindOfClass:[NSString class]])
        {
            return [[Update alloc]initWithSTMT:param];
        }
        else if ([param isSubclassOfClass:[FFDataBaseModel class]])
        {
            return [[Update alloc]initWithTable:param];
        }
        return [[Update alloc]initWithSTMT:param];
    };
}

- (Set *(^)(id))set
{
    return ^(id param){
        if ([param isKindOfClass:[NSArray class]])
        {
            return [[Set alloc]initWithSTMT:self.stmt columns:param];
        }
        return [[Set alloc]initWithSTMT:self.stmt format:param];
    };
}


@end
