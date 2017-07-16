//
//  FFDataBaseModel+Custom.h
//  FFDB
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel.h"

@interface FFDataBaseModel (Custom)

+ (NSArray *)memoryColumns;

+ (NSDictionary *)columnsType;

+ (NSArray *)columsOfSelf;

@end
