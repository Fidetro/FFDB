//
//  NSObject+FIDProperty.m
//  runtimeCategory
//
//  Created by Fidetro on 2016/11/4.
//  Copyright © 2016年 Fidetro. All rights reserved.
//

#import "NSObject+FIDProperty.h"


@implementation NSObject (FIDProperty)


+ (NSArray *)propertyOfSelf{
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    NSMutableArray *propertyNames = [NSMutableArray array];
    for (int i = 0; i < count; i++)
    {
        Ivar ivar = ivarList[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(ivar)];
        NSString *key;
        if ([[name substringToIndex:1] isEqualToString:@"_"])
        {
            key = [name substringFromIndex:1];
        }
        else
        {
            key = [name substringFromIndex:0];
        }
        [propertyNames addObject:key];
    }
    free(ivarList);
    
    return [propertyNames copy];
}

- (NSArray *)getPublicObject
{
    
    NSMutableArray *objectArray = [NSMutableArray array];
    unsigned int outCount;
    Ivar * ivars = class_copyIvarList([self class], &outCount);
    for (int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        
        [objectArray addObject:object_getIvar(self, ivar)];
    }
    return [objectArray copy];
}

- (NSDictionary *)modelToDictionary
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableDictionary *objectParams = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            [objectParams setObject:@"" forKey:propertyName];
        }
        else
        {
            [objectParams setObject:[self sendGetMethodWithPropertyName:propertyName] forKey:propertyName];
        }
    }
    
    return [objectParams copy];
}

- (NSDictionary *)modelToDictionaryHaveNilProperty
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableDictionary *objectParams = [NSMutableDictionary dictionary];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            continue;
        }
        
        [objectParams setObject:[self sendGetMethodWithPropertyName:propertyName] forKey:propertyName];
    }
    
    return [objectParams copy];
}

- (NSArray *)modelToArray
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableArray *objectArray = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            [objectArray addObject:@""];
        }
        else
        {
        [objectArray addObject:[self sendGetMethodWithPropertyName:propertyName]];
        }
    }
    
    return [objectArray copy];
}

- (NSDictionary *)modelToArrayHaveNilProperty
{
    NSArray *propertyNames = [[self class] propertyOfSelf];
    NSMutableArray *objectArray = [NSMutableArray array];
    
    for (NSString *propertyName in propertyNames)
    {
        
        if ([[self sendGetMethodWithPropertyName:propertyName] class] == nil)
        {
            continue;
        }
        else
        {
            [objectArray addObject:[self sendGetMethodWithPropertyName:propertyName]];
        }
    }
    
    return [objectArray copy];
}

- (id)sendGetMethodWithPropertyName:(NSString *)propertyName{
//    SEL getSel = NSSelectorFromString(propertyName);
//    if ([self respondsToSelector:getSel]) {
//    return [self performSelector:getSel];
//    }
//    return nil;
    
    return [self valueForKey:propertyName];
    
}
- (void)setPropertyWithName:(NSString *)propertyName object:(id)object{
//    NSString *firstCharater = [propertyName substringToIndex:1].uppercaseString;
//    NSString *setPropertyName = [NSString stringWithFormat:@"set%@%@:",firstCharater,[propertyName substringFromIndex:1]];
//    SEL setSel = NSSelectorFromString(setPropertyName);
//    [self performSelector:setSel withObject:object];
    
    [self setValue:object forKey:propertyName];
    
}

//获取属性名称数组
+ (NSDictionary *)propertysType
{
    
    NSMutableDictionary *results = [[NSMutableDictionary alloc] init];
    
    unsigned int outCount, i;
    objc_property_t *properties = class_copyPropertyList(self, &outCount);
    for (i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        const char *propName = property_getName(property);
        if(propName) {
            const char *propType = getPropertyType(property);
            NSString *propertyName = [NSString stringWithUTF8String:propName];
            NSString *propertyType = [NSString stringWithUTF8String:propType];
            
            NSLog(@"propertyName %@ propertyType %@", propertyName, propertyType);
            
            [results setObject:propertyType forKey:propertyName];
        }
    }
    free(properties);
    
    // returning a copy here to make sure the dictionary is immutable
    return [NSDictionary dictionaryWithDictionary:results];
}

static const char *getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a C primitive type:
            
            // if you want a list of what will be returned for these primitives, search online for
            // "objective-c" "Property Attribute Description Examples"
            // apple docs list plenty of examples of what you get for int "i", long "l", unsigned "I", struct, etc.
            
            NSString *name = [[NSString alloc] initWithBytes:attribute + 1 length:strlen(attribute) - 1 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            NSString *name = [[NSString alloc] initWithBytes:attribute + 3 length:strlen(attribute) - 4 encoding:NSASCIIStringEncoding];
            return (const char *)[name cStringUsingEncoding:NSASCIIStringEncoding];
        }
    }
    return "";
}


@end
