//
//  LZ201710Model.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZBaseModel.h"

@class listData;
@interface LZ201710Model : LZBaseModel

@property (nonatomic, strong) NSMutableArray<listData *> *data;
@property (nonatomic, copy) NSString     *code;
@property (nonatomic, copy) NSString     *error;
- (NSDictionary *)getModelData;

@end

@interface listData: LZBaseModel

/** 标题*/
@property (nonatomic, copy) NSString     *title;
/** 控制器名称 */
@property (nonatomic, copy) NSString     *className;
@end


