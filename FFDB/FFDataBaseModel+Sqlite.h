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


- (id)getIvarWithName:(NSString *)propertyname;
@end
