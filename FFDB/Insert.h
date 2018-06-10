//
//  Insert.h
//  FFDB
//
//  Created by Fidetro on 2018/6/6.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Into.h"
@interface Insert : STMT
+ (Insert *(^)(NSString *))begin;
- (Into *(^)(id))into;
@end
