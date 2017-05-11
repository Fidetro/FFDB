//
//  FFDBManager.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FMDatabase+FFExtern.h"


@interface FFDBManager : NSObject

+ (FMDatabase *)getDatabase;
@end
