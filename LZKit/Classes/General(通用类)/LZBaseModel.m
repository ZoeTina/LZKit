//
//  LZBaseModel.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZBaseModel.h"

@implementation LZBaseModel

-(void)setValue:(id)value forKey:(NSString *)key{
    if ([value isKindOfClass:[NSNumber class]]) {
        [self setValue:[NSString stringWithFormat:@"%@",value] forKey:key];
    }else{
        [super setValue:value forKey:key];
    }
}
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    YYLog(@"还没有定义%@",key);
}

@end
