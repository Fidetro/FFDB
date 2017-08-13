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
 get class table name
 
 @return table name
 */
+ (NSString *)tableName;
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
 custom columns
 
 @return <#return value description#>
 */
+ (NSArray *)columnsOfSelf;

@end
