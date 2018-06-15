//
//  Columns.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Values.h"
@interface Columns : STMT

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format;

- (instancetype)initWithSTMT:(NSString *)stmt columns:(NSArray<NSString *>*)columns;

- (Values *(^)(id))values;

@end
