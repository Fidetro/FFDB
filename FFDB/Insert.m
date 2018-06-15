//
//  Insert.m
//  FFDB
//
//  Created by Fidetro on 2018/6/6.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Insert.h"

@implementation Insert

- (instancetype)initWithSTMT:(NSString *)stmt
{
    self = [super init];
    if (self) {
        if ([stmt length] == 0)
        {
            self.stmt = [NSString stringWithFormat:@"insert "];
        }else
        {
            self.stmt = [NSString stringWithFormat:@"insert %@ ",stmt];
        }
    }
    return self;
}

+ (Insert *(^)(NSString *))begin
{
    return ^(NSString *stmt){
        return [[Insert alloc]initWithSTMT:stmt];
    };
}

- (Into *(^)(id))into
{
    return ^(id param){
        if ([param isKindOfClass:[NSString class]]) {
            return [[Into alloc]initWithSTMT:self.stmt format:param];
        }else  if ([param isSubclassOfClass:[FFDataBaseModel class]]) {
            return [[Into alloc]initWithSTMT:self.stmt table:param];
        }
        return [[Into alloc]initWithSTMT:self.stmt format:param];
    };
}


@end
