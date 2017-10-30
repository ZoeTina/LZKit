//
//  AppConstant.h
//  LZExtension
//
//  Created by 寜小陌 on 2017/10/9.
//  Copyright © 2017年 寜小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "YYExtensions.h"


#ifndef AppConstant_h
#define AppConstant_h


#ifdef DEBUG
#define YYLog(...) NSLog(@"%s 第%d行 \n %@\n\n",__func__,__LINE__,[NSString stringWithFormat:__VA_ARGS__])
#else
#define YYLog(...)
#endif
#define kSysVersion      ([[[UIDevice currentDevice] systemVersion] floatValue])

#define SafeAreaBottomHeight (kScreenHeight == 812.0 ? 34 : 0)
#define SafeAreaHeight 20

#define kColorWithRGBA(r, g, b, a)[UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define kColorWithRGB(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
// 3.设置随机颜色
#define kRandomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1.0]

/// RGB颜色(16进制)
#define UIColorHexString(rgbValue)    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define textColorNormal kColorWithRGB(0, 0, 0)
#define textColorSelected kColorWithRGB(42, 180, 228)
#define lineColors kColorWithRGB(215, 215, 215)

#define font(x) [UIFont fontWithName:@"PingFangSC-Regular" size:x]

//G－C－D
#define GLOBAL(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define MAIN(block) dispatch_async(dispatch_get_main_queue(),block)

// 6.弱引用/强引用
#define LZWeakSelf(type)  __weak typeof(type) weak##type = type;
#define LZStrongSelf(type)  __strong typeof(type) type = weak##type;

//View 圆角和加边框
#define ViewBorderRadius(View, Radius, Width, Color)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES];\
[View.layer setBorderWidth:(Width)];\
[View.layer setBorderColor:[Color CGColor]]

// View 圆角
#define ViewRadius(View, Radius)\
\
[View.layer setCornerRadius:(Radius)];\
[View.layer setMasksToBounds:YES]

//拼接字符串
#define NSStringFormat(format,...) [NSString stringWithFormat:format,##__VA_ARGS__]

//获取屏幕 宽度、高度 -- //获取屏幕尺寸
#define YYScreenWidth   ([UIScreen mainScreen].bounds.size.width)
#define YYScreenHeight  ([UIScreen mainScreen].bounds.size.height)
#define YYScreenBounds  ([UIScreen mainScreen].bounds)

#define kScreenWidth    ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight   ([UIScreen mainScreen].bounds.size.height)
#define kScreenBounds   ([UIScreen mainScreen].bounds)

// 横屏宽度
#define kCrossScreenWidth (ScreenWidth > ScreenHeight ?  ScreenHeight : ScreenWidth)
// 横屏高度
#define kCrossScreenHeight (ScreenWidth > ScreenHeight ?  ScreenWidth : ScreenHeight)

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#define kiPhoneX ((kNavBarHeight == 88) ? YES : NO)
// 依照iPhone6的尺寸设计
#define GETPIXEL (YYScreenWidth / 375)
#define AUTOLAYOUTSIZE(size) (size * GETPIXEL)
//计算比例后的宽度
#define AUTOLAYOUTSIZE_W(with)  (with*(YYScreenWidth/375.0f))
//计算比例后高度
#define AUTOLAYOUTSIZE_H(height)  (height*(YYScreenHeight/667.0f))

// 读取本地图片资源
#define kGetImage(imageName) [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]]
#define kLoadImage(file,ext) [UIImage imageWithContentsOfFile:［NSBundle mainBundle]pathForResource:file ofType:ext］
//定义UIImage对象
#define kImage(A) [UIImage imageWithContentsOfFile:［NSBundle mainBundle] pathForResource:A ofType:nil］

//移除iOS7之后，cell默认左侧的分割线边距   Preserve:保存（\：换行）
#define kRemoveCellSeparator \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
cell.separatorInset = UIEdgeInsetsZero;\
cell.layoutMargins = UIEdgeInsetsZero; \
cell.preservesSuperviewLayoutMargins = NO; \
}

//字符串是否为空
#define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
//数组是否为空
#define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
//字典是否为空
#define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)
#define kNumIsEmpty(num) (num !=nil && [num isKindOfClass:[NSNumber class]])

//获取一段时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)
//打印当前方法名
#define ITTDPRINTMETHODNAME() ITTDPRINT(@"%s", __PRETTY_FUNCTION__)

//是否是空对象
#define kObjectIsEmpty(_object) (_object == nil \
|| [_object isKindOfClass:[NSNull class]] \
|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \
|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

#ifndef LZSYNTH_DUMMY_CLASS
#define LZSYNTH_DUMMY_CLASS(_name_) \
@interface LZSYNTH_DUMMY_CLASS_ ## _name_ : NSObject @end \
@implementation LZSYNTH_DUMMY_CLASS_ ## _name_ @end
#endif

//单例化一个类
#define SINGLETON_FOR_HEADER(className) \
\
+ (className *)shared##className;

#define SINGLETON_FOR_CLASS(className) \
\
+ (className *)shared##className { \
static className *shared##className = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
shared##className = [[self alloc] init]; \
}); \
return shared##className; \
}

// 一些缩写(获取系统对象)
#define kApplication        [UIApplication sharedApplication]
#define kMainWindow         [UIApplication sharedApplication].keyWindow
#define kAppDelegate        [UIApplication sharedApplication].delegate
#define kRootViewController [UIApplication sharedApplication].delegate.window.rootViewController
// NSUserDefaults 实例化
#define kUserDefaults       [NSUserDefaults standardUserDefaults]
// 获取通知中心
#define kNotificationCenter [NSNotificationCenter defaultCenter]

// 发送通知
#define kPostNotification(name,obj) [[NSNotificationCenter defaultCenter] postNotificationName:name object:obj];

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height

#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight (kStatusBarHeight + kNavBarHeight)
#endif /* AppConstant_h */
