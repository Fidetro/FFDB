//
//  Alter.h
//  FFDB
//
//  Created by Fidetro on 2018/6/9.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import "STMT.h"
#import "Add.h"
@interface Alter : STMT

+ (Alter *(^)(id))begin;

- (Add *(^)(NSString *,id))add;

@end
