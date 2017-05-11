//
//  FFDataBaseModel+Sqlite.h
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"

@interface FFDataBaseModel (Sqlite)

+ (NSString *)createTableSqlstatement;

+ (NSString *)selectObjectSqlstatementWithFormat:(NSString *)format;

- (NSString *)insertObjectSqlstatement;

- (NSString *)updateObjectSqlStatementWithColumns:(NSArray <NSString *>*)columns;

- (NSString *)deleteObjectSqlstatement;

+ (NSString *)deleteObjectSqlstatementWithFormat:(NSString *)format;


@end
