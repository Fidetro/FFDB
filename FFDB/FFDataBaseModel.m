//
//  FIDDataBaseModel.m
//  FFDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//
//  https://github.com/Fidetro/FFDB

#import "FFDataBaseModel.h"
#import "FFDataBaseModel+Sqlite.h"
#import "FFDataBaseModel+Custom.h"
#import "NSObject+FIDProperty.h"

NSString const* kUpdateContext = @"kUpdateContext";

@interface FFDataBaseModel ()

@property(nonatomic,strong,readwrite) NSString *primaryID;
@end

@implementation FFDataBaseModel

+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassAllObject
{
    return [[self class] selectFromClassWhereFormat:nil values:nil];
}

+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassWhereFormat:(NSString *)format
                                                             values:(NSArray <id>*)values
{
    return [FFDBManager selectFromClass:[self class] columns:nil where:format values:values toClass:nil db:nil];
}

+ (BOOL)deleteFromClassAllObject
{
    return [[self class]deleteFromClassWhereFormat:nil values:nil];
}

+ (BOOL)deleteFromClassWhereFormat:(NSString *)whereFormat
                            values:(NSArray <id>*)values
{
    return [FFDBManager deleteFromClass:[self class] where:whereFormat values:values db:nil];
}

- (BOOL)insertObject
{
    return [self insertObject:nil];
}

- (BOOL)insertObject:(FMDatabase *)db
{
    NSMutableArray *propertyNames = [NSMutableArray arrayWithArray:[[self class]columnsOfSelf]];
    [propertyNames removeObject:[[self class]primaryKeyColumn]];
    return [FFDBManager insertObject:self columns:[propertyNames copy] values:nil db:db];
}

- (BOOL)insertObjectWithColumns:(NSArray *)columns
{
    return [FFDBManager insertObject:self columns:columns values:nil db:nil];
}

- (BOOL)deleteObject
{
    return [self deleteObject:nil];
}

- (BOOL)deleteObject:(FMDatabase *)db
{
    return [FFDBManager deleteFromClass:[self class] where:[NSString stringWithFormat:@"%@ = ?",[[self class] primaryKeyColumn]] values:@[[self getIvarWithName:[[self class] primaryKeyColumn]]] db:db];
}



+ (BOOL)updateFromClassSet:(NSArray <NSString *>*)setColumns
                     where:(NSString *)whereFormat
                    values:(NSArray <id>*)values
{
    
    return [FFDBManager updateFromClass:self set:setColumns where:whereFormat values:values db:nil];
}

- (BOOL)updateObject
{
    return [self updateObject:nil];
}

- (BOOL)updateObject:(FMDatabase *)db
{
    return [self updateObjectByCloumns:nil db:db];
}


- (BOOL)updateObjectByCloumns:(NSArray *)columns db:(FMDatabase *)db
{
    if (columns.count == 0)
    {
        columns = [[self class]columnsOfSelf];
    }
    NSMutableArray *muColumns = [NSMutableArray arrayWithArray:columns];
    NSMutableArray *values = [NSMutableArray array];
    for (NSString *column in muColumns)
    {
        id value = [self getIvarWithName:column];
        [values addObject:value];
    }
    [muColumns removeObject:[[self class] primaryKeyColumn]];
    [values addObject:[self getIvarWithName:[[self class] primaryKeyColumn]]];
    return [FFDBManager updateFromClass:[self class] set:columns where:[NSString stringWithFormat:@"%@ = ?",[[self class] primaryKeyColumn]] values:values db:db];

}



#pragma mark - --------------------------base method--------------------------








+ (void)initialize
{
    if ([NSStringFromClass([self class])isEqualToString:@"FFDataBaseModel"])
    {
        return;
    }
    else if ([NSStringFromClass([self class])rangeOfString:@"NSKVONotifying"].location != NSNotFound)
    {
        return;
    }
    else
    {
        [FFDBManager createTableFromClass:self];
        [FFDBManager alterFromClass:self];
    }
}

@end


