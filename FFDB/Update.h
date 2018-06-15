//
//  Update.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Set.h"
@interface Update : STMT

+ (Update *(^)(id))begin;

- (Set *(^)(id))set;

@end
