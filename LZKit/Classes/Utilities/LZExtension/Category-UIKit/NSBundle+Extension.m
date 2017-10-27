//
//  NSBundle+SCExtension.m
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/20.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (NSString *)lz_currentVersion {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleShortVersionString"];
}

+ (UIImage *)lz_launchImage {
    
    NSArray *launchImages = [NSBundle mainBundle].infoDictionary[@"UILaunchImages"];
    
    NSString *sizeString = NSStringFromCGSize([UIScreen mainScreen].bounds.size);
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"UILaunchImageOrientation = 'Portrait' AND UILaunchImageSize = %@", sizeString];
    NSArray *result = [launchImages filteredArrayUsingPredicate:predicate];
    
    NSString *imageName = result.lastObject[@"UILaunchImageName"];
    
    return [UIImage imageNamed:imageName];
}

+ (NSString *)lz_namespace {
    return [NSBundle mainBundle].infoDictionary[@"CFBundleName"];
}

@end
