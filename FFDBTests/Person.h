//
//  Person.h
//  FFDBTests
//
//  Created by Fidetro on 2018/12/1.
//  Copyright © 2018 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person : FFDataBaseModel

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int priamryID;
@end

NS_ASSUME_NONNULL_END
