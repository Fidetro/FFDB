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


@class FFDataBaseModel;

@interface FFDBManager : NSObject

+ (NSArray <__kindof FFDataBaseModel *>*)selectColumns:(NSArray <NSString *>*)columns
                 fromClass:(Class)dbClass
    SQLStatementWithFormat:(NSString *)format;

+ (NSArray <__kindof FFDataBaseModel *>*)selectColumns:(NSArray <NSString *>*)columns
                                           fromClasses:(NSArray <Class>*)dbClasses
                                               toClass:(Class)toClass
                                SQLStatementWithFormat:(NSString *)format;


+ (BOOL)deleteFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format;

+ (BOOL)insertObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns;

+ (BOOL)updateFromClass:(Class)dbClass
 SQLStatementWithFormat:(NSString *)format;

+ (BOOL)updateObject:(__kindof FFDataBaseModel *)model
             columns:(NSArray <NSString *>*)columns;

+ (void)alertFromClass:(Class)dbClass
               columns:(NSArray <NSString *>*)columns;

+ (BOOL)createTableFromClass:(Class)dbClass;

+ (NSString *)databasePath;

+ (FMDatabase *)database;



@end
