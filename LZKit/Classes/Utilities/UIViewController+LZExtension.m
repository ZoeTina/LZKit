//
//  UIViewController+LZExtension.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "UIViewController+LZExtension.h"
#import "LZNavigationBarViewController.h"
#import <objc/runtime.h>

NSString *const LZViewControllerPropertyChangedNotification = @"LZViewControllerPropertyChangedNotification";

static const void *LZInteractivePopKey  = @"LZInteractivePopKey";
static const void *LZFullScreenPopKey   = @"LZFullScreenPopKey";
static const void *LZPopMaxDistanceKey  = @"LZPopMaxDistanceKey";
static const void *LZNavBarAlphaKey     = @"LZNavBarAlphaKey";
static const void *LZStatusBarStyleKey  = @"LZStatusBarStyleKey";
static const void *LZStatusBarHiddenKey = @"LZStatusBarHiddenKey";
static const void *LZBackStyleKey       = @"LZBackStyleKey";
static const void *LZPushDelegateKey    = @"LZPushDelegateKey";

@implementation UIViewController (LZExtension)

// 使用static inline创建静态内联函数，方便调用
static inline void lz_swizzled_method(Class class ,SEL originalSelector, SEL swizzledSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL isAdd = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (isAdd) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

// 方法交换
+ (void)load {
    // 保证其只执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        lz_swizzled_method(class, @selector(viewDidAppear:) ,@selector(lz_viewDidAppear:));
    });
}

- (void)lz_viewDidAppear:(BOOL)animated {
    
    // 在每次视图出现的时候重新设置当前控制器的手势
    [[NSNotificationCenter defaultCenter] postNotificationName:LZViewControllerPropertyChangedNotification
                                                        object:@{@"viewController": self}];
    
    [self lz_viewDidAppear:animated];
}

#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden {
    return self.lz_StatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.lz_statusBarStyle;
}

#pragma mark - Added Property
- (BOOL)lz_interactivePopDisabled {
    return [objc_getAssociatedObject(self, LZInteractivePopKey) boolValue];
}

- (void)setLz_interactivePopDisabled:(BOOL)lz_interactivePopDisabled {
    objc_setAssociatedObject(self, LZInteractivePopKey, @(lz_interactivePopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LZViewControllerPropertyChangedNotification
                                                        object:@{@"viewController": self}];
}

- (BOOL)lz_fullScreenPopDisabled {
    return [objc_getAssociatedObject(self, LZFullScreenPopKey) boolValue];
}

- (void)setLz_fullScreenPopDisabled:(BOOL)lz_fullScreenPopDisabled {
    objc_setAssociatedObject(self, LZFullScreenPopKey, @(lz_fullScreenPopDisabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LZViewControllerPropertyChangedNotification
                                                        object:@{@"viewController": self}];
}

- (CGFloat)lz_popMaxAllowedDistanceToLeftEdge {
    return [objc_getAssociatedObject(self, LZPopMaxDistanceKey) floatValue];
}

- (void)setLz_popMaxAllowedDistanceToLeftEdge:(CGFloat)lz_popMaxAllowedDistanceToLeftEdge {
    objc_setAssociatedObject(self, LZPopMaxDistanceKey, @(lz_popMaxAllowedDistanceToLeftEdge), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 当属性改变时，发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LZViewControllerPropertyChangedNotification
                                                        object:@{@"viewController": self}];
}

- (CGFloat)lz_navBarAlpha {
    return [objc_getAssociatedObject(self, LZNavBarAlphaKey) floatValue];
}

- (void)setLz_navBarAlpha:(CGFloat)lz_navBarAlpha {
    objc_setAssociatedObject(self, LZNavBarAlphaKey, @(lz_navBarAlpha), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNavBarAlpha:lz_navBarAlpha];
}

- (UIStatusBarStyle)lz_statusBarStyle {
    id style = objc_getAssociatedObject(self, LZStatusBarStyleKey);
    return (style != nil) ? [style integerValue] : UIStatusBarStyleDefault;
}

- (void)setLz_statusBarStyle:(UIStatusBarStyle)lz_statusBarStyle {
    objc_setAssociatedObject(self, LZStatusBarStyleKey, @(lz_statusBarStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (BOOL)lz_StatusBarHidden {
    return [objc_getAssociatedObject(self, LZStatusBarHiddenKey) boolValue];
}

- (void)setLz_StatusBarHidden:(BOOL)lz_StatusBarHidden {
    objc_setAssociatedObject(self, LZStatusBarHiddenKey, @(lz_StatusBarHidden), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (LZNavigationBarBackStyle)lz_backStyle {
    id style = objc_getAssociatedObject(self, LZBackStyleKey);
    
    return (style != nil) ? [style integerValue] : LZNavigationBarBackStyleBlack;
}

- (void)setLz_backStyle:(LZNavigationBarBackStyle)lz_backStyle {
    objc_setAssociatedObject(self, LZBackStyleKey, @(lz_backStyle), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id<LZViewControllerPushDelegate>)lz_pushDelegate {
    return objc_getAssociatedObject(self, LZPushDelegateKey);
}

- (void)setLz_pushDelegate:(id<LZViewControllerPushDelegate>)lz_pushDelegate {
    objc_setAssociatedObject(self, LZPushDelegateKey, lz_pushDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setNavBarAlpha:(CGFloat)alpha {
    
    UINavigationBar *navBar = nil;
    
    if ([self isKindOfClass:[LZNavigationBarViewController class]]) {
        LZNavigationBarViewController *vc = (LZNavigationBarViewController *)self;
        navBar = vc.lz_navigationBar;
        
        UIView *barBackgroundView = [navBar.subviews objectAtIndex:0];
        barBackgroundView.alpha = alpha;
        
    }else {
        navBar = self.navigationController.navigationBar;
        
        UIView *barBackgroundView = [navBar.subviews objectAtIndex:0]; // _UIBarBackground
        UIImageView *backgroundImageView = [barBackgroundView.subviews objectAtIndex:0]; // UIImageView
        
        if (navBar.isTranslucent) {
            if (backgroundImageView != nil && backgroundImageView.image != nil) {
                barBackgroundView.alpha = alpha;
            }else {
                UIView *backgroundEffectView = [barBackgroundView.subviews objectAtIndex:1]; // UIVisualEffectView
                if (backgroundEffectView != nil) {
                    backgroundEffectView.alpha = alpha;
                }
            }
        }else {
            barBackgroundView.alpha = alpha;
        }
    }
    // 底部分割线
    navBar.clipsToBounds = alpha == 0.0;
}

- (UIViewController *)lz_visibleViewControllerIfExist {
    
    if (self.presentedViewController) {
        return [self.presentedViewController lz_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        return [((UINavigationController *)self).topViewController lz_visibleViewControllerIfExist];
    }
    
    if ([self isKindOfClass:[UITabBarController class]]) {
        return [((UITabBarController *)self).selectedViewController lz_visibleViewControllerIfExist];
    }
    
    if ([self isViewLoaded] && self.view.window) {
        return self;
    }else {
        YYLog(@"找不到可见的控制器，viewcontroller.self = %@, self.view.window = %@", self, self.view.window);
        return nil;
    }
}
@end
