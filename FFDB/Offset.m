//
//  Offset.m
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "Offset.h"

@implementation Offset
- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format
{
    self = [super init];
    if (self)
    {
        self.stmt = [NSString stringWithFormat:@"%@offset %@ ",stmt,format];
    }
    return self;
}
@end
