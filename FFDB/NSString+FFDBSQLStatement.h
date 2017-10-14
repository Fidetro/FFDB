//
//  NSString+FFDBSQLStatement.h
//  FFDB
//
//  Created by Fidetro on 2017/7/23.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FFDataBaseModel;

@interface NSString (FFDBSQLStatement)

+ (NSString *)stringWithSelectCountfromClasses:(NSArray <Class>*)dbClasses
                        SQLStatementWithFormat:(NSString *)format;

+ (NSString *)stringWithSelectColumns:(NSArray <NSString *>*)columns
                          fromClasses:(NSArray <Class>*)dbClasses
               SQLStatementWithFormat:(NSString *)format;

+ (NSString *)stringWithDeleteFromClass:(Class)dbClass
                 SQLStatementWithFormat:(NSString *)format;

+ (NSString *)stringWithInsertObject:(__kindof FFDataBaseModel *)dbModel
                             columns:(NSArray <NSString *>*)columns;


+ (NSString *)stringWithUpdateFromClass:(Class)dbClass
                 SQLStatementWithFormat:(NSString *)format;

+ (NSString *)stringWithUpdateObject:(__kindof FFDataBaseModel *)dbModel
                             columns:(NSArray <NSString *>*)columns;

+ (NSString *)stringWithCreateTableFromClass:(Class)dbClass;


@end
