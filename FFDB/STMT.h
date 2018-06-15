//
//  STMT.h
//  FFDB
//
//  Created by Fidetro on 2018/6/6.
//  Copyright © 2018年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FFDataBaseModel.h"
#import "FFDataBaseModel+Custom.h"
#import "FMDatabase+FFExtern.h"


@interface STMT : NSObject

@property(nonatomic,strong) NSString *stmt;


- (void(^)(NSArray <id>*,FMDatabase *,UpdateResult))endUpdate;

- (void(^)(NSArray <id>*,Class,FMDatabase *,QueryResult))endQuery;


@end
