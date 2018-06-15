//
//  CustomModel.h
//  FFDBTests
//
//  Created by Fidetro on 2017/8/27.
//  Copyright © 2017年 Fidetro. All rights reserved.
//

#import "FFDataBaseModel.h"

@interface CustomModel : FFDataBaseModel

@property (nonatomic,strong)NSString *_id;
@property (nonatomic,strong)NSString *_name;
@property (nonatomic,strong)NSString *mem;
@property (nonatomic,assign)NSInteger coustomKey;
@end
