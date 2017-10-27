//
//  NSBundle+SCExtension.h
//  SiChuanFocus
//
//  Created by Ensem on 2017/6/20.
//  Copyright © 2017年 Ensem. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  此分类增加了一些关于NSBundle的有用方法
 */
@interface NSBundle (Extension)

/** 当前版本号字符串 */
+ (nullable NSString *)lz_currentVersion;

/** 与当前屏幕尺寸匹配的启动图像 */
+ (nullable UIImage *)lz_launchImage;

/** 取BundleName */ 
+ (nullable NSString *)lz_namespace;

@end
