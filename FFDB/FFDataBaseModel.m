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
    return [[self class] selectFromClassPredicateWithFormat:nil values:nil];
}

+ (NSArray <__kindof FFDataBaseModel *>*)selectFromClassPredicateWithFormat:(NSString *)format
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
    NSArray *propertyNames = [[self class]columnsOfSelf];
    
    return [FFDBManager insertObject:self columns:propertyNames values:nil db:nil];
}

- (BOOL)insertObjectWithColumns:(NSArray *)columns
{
    return [FFDBManager insertObject:self columns:columns values:nil db:nil];
}

+ (BOOL)updateFromClassSet:(NSArray <NSString *>*)setColumns
                     where:(NSString *)whereFormat
                    values:(NSArray <id>*)values
{
    
    return [FFDBManager updateFromClass:self set:setColumns where:whereFormat values:values db:nil];
}





- (void)updateObjectWithBlock:(void(^)())update_block
{
    NSArray *propertyNames = [[self class]columnsOfSelf];
    if (update_block)
    {
        for (NSString *propertyName in propertyNames)
        {
            [self addObserver:self forKeyPath:propertyName options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:&kUpdateContext];
        }
        update_block();
        for (NSString *propertyName in propertyNames)
        {
            [self removeObserver:self forKeyPath:propertyName];
        }
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if (context == &kUpdateContext)
    {
        #warning fix me
//        [self updateObjectSetColumns:@[keyPath]];
    }
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


