//
//  Person.h
//  FIDDB
//
//  Created by Fidetro on 2017/3/22.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FIDDataBaseModel.h"

@interface Person : FIDDataBaseModel
/** <#Description#> **/
@property(nonatomic,copy) NSString *name;
/** <#Description#> **/
@property(nonatomic,copy) NSString *age;
@end
