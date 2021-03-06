//
//  Limit.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Offset.h"
@interface Limit : STMT
- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format;

- (Offset *(^)(NSString *))offset;

@end
