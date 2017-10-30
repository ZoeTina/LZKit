//
//  LZ201710Model.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZ201710Model.h"

@implementation LZ201710Model

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [listData class]};
}

- (NSDictionary *)getModelData{

    NSString *path = [[NSBundle mainBundle] pathForResource:@"LZ201710View"
                                                     ofType:@"json"];

    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    return dictionary;
}


@end

@implementation listData

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
