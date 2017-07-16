//
//  Classroom.h
//  FFDB
//
//  Created by Fidetro on 2017/3/26.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"

@interface ClassRoom : FFDataBaseModel
/** classroom name **/
@property(nonatomic,copy) NSString *name;
/** number **/
@property(nonatomic,copy) NSString *number;

@end
