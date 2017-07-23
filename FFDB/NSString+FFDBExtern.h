//
//  NSString+FFDBExtern.h
//  FFDB
//
//  Created by Fidetro on 2017/7/23.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (FFDBExtern)

+ (NSString *)stringWithColumns:(NSArray <NSString *>*)columns;

+ (NSString *)stringWithTableNameOfClasses:(NSArray <Class>*)dbClasses;


@end
