//
//  FFDataBaseModel+Sqlite.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel.h"

@interface FFDataBaseModel (Sqlite)


/**
 DELETE SQL statement String

 @return SQL statement String
 */
- (NSString *)deleteObjectSqlstatement;

/**
 UPDATE Object SQL statement String
 
 @return SQL statement String
 */
- (NSString *)updateObjectSqlstatement;

- (NSString *)stringWithInsertValueOfColumns:(NSArray <NSString *>*)columns;

- (NSString *)stringWithUpdateSetValueOfColumns:(NSArray <NSString *>*)columns;

- (NSString *)stringWithWhereValueOfColumns:(NSArray <NSString *>*)columns;

+ (NSString *)stringToColumnTypeWithColumns:(NSArray <NSString *>*)columns;


@end
