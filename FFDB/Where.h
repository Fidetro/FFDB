//
//  Where.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "OrderBy.h"
#import "Limit.h"
#import "Offset.h"
@interface Where : STMT

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format;

- (OrderBy *(^)(NSString *))orderBy;

- (Limit *(^)(NSString *))limit;

- (Offset *(^)(NSString *))offset;

@end
