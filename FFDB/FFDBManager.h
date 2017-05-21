//
//  FFDBManager.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>
#import "FMDatabase+FFExtern.h"

@class FFDataBaseModel;

@interface FFDBManager : NSObject

+ (NSString *)databasePath;

+ (FMDatabase *)database;



@end
