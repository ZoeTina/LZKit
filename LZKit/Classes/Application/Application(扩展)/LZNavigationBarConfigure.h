//
//  LZNavigationBarConfigure.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

// 图片路径
#define LZSrcName(file) [@"LZNavigationBarViewController.bundle" stringByAppendingPathComponent:file]

//#define LZFrameworkSrcName(file) [@"Frameworks/LZNavigationBarViewController.framework/LZNavigationBarViewController.bundle" stringByAppendingPathComponent:file]
//
//#define LZImage(file)  [UIImage imageNamed:LZSrcName(file)] ? : [UIImage imageNamed:LZFrameworkSrcName(file)]

#define LZConfigure [LZNavigationBarConfigure sharedInstance]

typedef NS_ENUM(NSUInteger, LZNavigationBarBackStyle) {
    LZNavigationBarBackStyleBlack,   // 黑色返回按钮
    LZNavigationBarBackStyleWhite    // 白色返回按钮
};

@interface LZNavigationBarConfigure : NSObject

/** 导航栏背景色 */
@property (nonatomic, strong) UIColor   *backgroundColor;
/** 导航栏标题颜色 */
@property (nonatomic, strong) UIColor   *titleColor;
/** 导航栏标题字体 */
@property (nonatomic, strong) UIFont    *titleFont;
/** 状态栏是否隐藏 */
@property (nonatomic, assign) BOOL      statusBarHidden;
/** 状态栏类型 */
@property (nonatomic, assign) UIStatusBarStyle          statusBarStyle;
/** 返回按钮类型 */
@property (nonatomic, assign) LZNavigationBarBackStyle  backStyle;

+ (instancetype) sharedInstance;
// 统一配置导航栏外观，最好在AppDelegate中配置
- (void)setupDefaultConfigure;

// 自定义
- (void)setupCustomConfigure:(void (^)(LZNavigationBarConfigure *configure))block;
// 获取当前显示的控制器
- (UIViewController *)visibleController;

@end
