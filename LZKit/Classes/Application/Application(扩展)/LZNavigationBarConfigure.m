//
//  LZNavigationBarConfigure.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZNavigationBarConfigure.h"
#import "UIViewController+LZExtension.h"

@implementation LZNavigationBarConfigure

static LZNavigationBarConfigure *instance = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [LZNavigationBarConfigure new];
    });
    return instance;
}

// 设置默认的导航栏外观
- (void)setupDefaultConfigure {
    
    self.backgroundColor = [UIColor whiteColor];
    self.titleColor      = [UIColor blackColor];
    self.titleFont       = [UIFont boldSystemFontOfSize:17.0];
    self.statusBarHidden = NO;
    self.statusBarStyle  = UIStatusBarStyleDefault;
    self.backStyle       = LZNavigationBarBackStyleBlack;
    
    // 待添加
}

- (void)setupCustomConfigure:(void (^)(LZNavigationBarConfigure *))block {
    [self setupDefaultConfigure];
    !block ? : block(self);
}

// 获取当前显示的控制器
- (UIViewController *)visibleController {
    return [[UIApplication sharedApplication].keyWindow.rootViewController lz_visibleViewControllerIfExist];
}
@end
