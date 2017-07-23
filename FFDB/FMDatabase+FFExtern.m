//
//  FMDatabase+FFExtern.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FMDatabase+FFExtern.h"

@implementation FMDatabase (FFExtern)

- (BOOL)executeUpdateWithSqlstatementAfterClose:(NSString *)sqlstatement
{
    BOOL update = NO;
    if ([self open])
    {
        update =  [self executeUpdate:sqlstatement];
    }
    [self close];
    return update;
}

- (BOOL)executeUpdateWithSqlstatement:(NSString *)sqlstatement
{
    BOOL update = NO;
    if ([self open])
    {
        update =  [self executeUpdate:sqlstatement];
    }
    
    return update;
}

@end
