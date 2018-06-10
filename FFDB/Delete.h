//
//  Delete.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "From.h"
@interface Delete : STMT

- (From *(^)(id))from;

+ (Delete *(^)(NSString *))begin;

@end
