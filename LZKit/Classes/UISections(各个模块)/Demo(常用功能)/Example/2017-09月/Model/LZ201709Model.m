//
//  LZ201709Model.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/29.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZ201709Model.h"

@implementation LZ201709Model

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [list1709Data class]};
}

- (NSDictionary *)getModelData{
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"LZ201709View"
                                                     ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:jsonData
                                                               options:NSJSONReadingAllowFragments
                                                                 error:nil];
    return dictionary;
}


@end

@implementation list1709Data

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID" : @"id"};
}

@end
