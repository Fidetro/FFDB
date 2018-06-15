//
//  Into.h
//  FFDB
//
//  Created by Fidetro on 2018/6/8.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "STMT.h"
#import "Columns.h"
@interface Into : STMT

- (instancetype)initWithSTMT:(NSString *)stmt format:(NSString *)format;

- (instancetype)initWithSTMT:(NSString *)stmt table:(Class)table;

- (Columns *(^)(id))columns;

@end
