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


/**
 If you want this property does not exist in the table colums,you need overwirte in subclass ,like:
 + (NSArray *)memoryPropertys
 {
    return @[@"memoryProperty"];
 }
 */
+ (NSArray *)memoryPropertys;

/**
 If you want custom columnType you need overwirte in subclass ,like:
 + (NSDictionary *)columnsType
 {
    return @{@"property":@"columnType"};
 }
 */
+ (NSDictionary *)columnsType;

/**
 If you want custom column you need overwirte in subclass ,like:
 
 + (NSDictionary *)customColumns
 {
 return @{@"d":@"dog"};
 }
 */
+ (NSDictionary *)customColumns;

/**
 table columns only readonly can't overwrite
 
 @return columns
 */
+ (NSArray *)columnsOfSelf;
/**
 get class table name
 
 @return table name
 */
+ (NSString *)tableName;


@end
