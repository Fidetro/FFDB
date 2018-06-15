//
//  Select.h
//  FFDB
//
//  Created by Fidetro on 2018/6/8.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "From.h"
@interface Select : STMT


+ (Select *(^)(id))begin;

- (From *(^)(id))from;

@end
