//
//  Add.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"

@interface Add : STMT


- (instancetype)initWithSTMT:(NSString *)stmt
                      column:(NSString *)column
                   columnDef:(NSString *)columnDef;

- (instancetype)initWithSTMT:(NSString *)stmt
                      column:(NSString *)column
                       table:(Class)table;

@end
