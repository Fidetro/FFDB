//
//  TestModel.h
//  FFDB
//
//  Created by Fidetro on 2017/7/16.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"

@interface TestModel : FFDataBaseModel

@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *memory;
@property(nonatomic,assign) NSUInteger testUint;
@property(nonatomic,assign) double time;
@end
