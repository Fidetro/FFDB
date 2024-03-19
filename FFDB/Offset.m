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
        if ([format length] == 0)
        {
            self.stmt = [NSString stringWithFormat:@"%@",stmt];
        }
        else
        {
            self.stmt = [NSString stringWithFormat:@"%@offset %@ ",stmt,format];
        }
    }
    return self;
}
@end
