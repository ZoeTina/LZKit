//
//  LZ201709Model.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/29.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZBaseModel.h"

@class list1709Data;
@interface LZ201709Model : LZBaseModel

@property (nonatomic, strong) NSMutableArray<list1709Data *> *data;
@property (nonatomic, copy) NSString     *code;
@property (nonatomic, copy) NSString     *error;
- (NSDictionary *)getModelData;

@end

@interface list1709Data: LZBaseModel

/** 标题*/
@property (nonatomic, copy) NSString     *title;
/** 控制器名称 */
@property (nonatomic, copy) NSString     *className;
@end
