//
//  From.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Where.h"
#import "Limit.h"
#import "OrderBy.h"
#import "Offset.h"
@interface From : STMT

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format;

- (instancetype)initWithSTMT:(NSString *)stmt table:(Class)table;

- (Where *(^)(NSString *))where;

- (OrderBy *(^)(NSString *))orderBy;

- (Limit *(^)(NSString *))limit;

- (Offset *(^)(NSString *))offset;

@end
