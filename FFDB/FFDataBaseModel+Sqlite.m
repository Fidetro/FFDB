//
//  FFDataBaseModel+Sqlite.m
//  FFDB
//
//  Created by Fidetro on 2017/5/11.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"
@implementation FFDataBaseModel (Sqlite)


- (id)getIvarWithName:(NSString *)propertyname
{
    id obj = [self sendGetMethodWithPropertyName:propertyname];
    
    if ([obj respondsToSelector:@selector(length)])
    {
        if ([obj length] == 0)
        {
            obj = @"";
        }
    }
    else if (obj == nil)
    {
        obj = @"";
    };
    if ([obj isKindOfClass:[NSString class]])
    {
//        NSString *str = obj;
//        [str stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
//        [str stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
//        [str stringByReplacingOccurrencesOfString:@"[" withString:@"/["];
//        [str stringByReplacingOccurrencesOfString:@"]" withString:@"/]"];
//        [str stringByReplacingOccurrencesOfString:@"%" withString:@"/%"];
//        [str stringByReplacingOccurrencesOfString:@"&" withString:@"/&"];
//        [str stringByReplacingOccurrencesOfString:@"_" withString:@"/_"];
//        [str stringByReplacingOccurrencesOfString:@"(" withString:@"/("];
//        [str stringByReplacingOccurrencesOfString:@")" withString:@"/)"];
    }
    return obj;
}

@end
