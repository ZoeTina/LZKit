//
//  UINavigationController+LZCategory.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/18.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "UINavigationController+LZCategory.h"
#import "LZNavigationBarViewController.h"
//#import "UIBarButtonItem+LZCategory.h"
#import <objc/runtime.h>

@implementation UINavigationController (LZCategory)

+ (instancetype)rootVC:(UIViewController *)rootVC translationScale:(BOOL)translationScale {
    return [[self alloc] initWithRootVC:rootVC translationScale:translationScale];
}

- (instancetype)initWithRootVC:(UIViewController *)rootVC translationScale:(BOOL)translationScale {
    if (self = [super init]) {
        [self pushViewController:rootVC animated:YES];
        self.lz_translationScale = translationScale;
    }
    return self;
}

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
        
        lz_swizzled_method(class, @selector(viewDidLoad), @selector(lz_viewDidLoad));
        lz_swizzled_method(class, @selector(pushViewController:animated:), @selector(lz_pushViewController:animated:));
    });
}

- (void)lz_viewDidLoad {
    // 隐藏系统导航栏
    [self setNavigationBarHidden:NO animated:NO];
    
    // 设置背景色
    self.view.backgroundColor = [UIColor blackColor];
    
    // 设置代理
    self.delegate = self.navDelegate;
    
    // 注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:LZViewControllerPropertyChangedNotification object:nil];
    
    [self lz_viewDidLoad];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LZViewControllerPropertyChangedNotification object:nil];
}

#pragma mark - Notification Handle
- (void)handleNotification:(NSNotification *)notify {
    
    UIViewController *vc = (UIViewController *)notify.object[@"viewController"];
    
    BOOL isRootVC = vc == self.viewControllers.firstObject;
    
    if (vc.lz_interactivePopDisabled) { // 禁止滑动
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
    }else if (vc.lz_fullScreenPopDisabled) { // 禁止全屏滑动
        
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.panGesture];
        
        if (self.lz_translationScale) {
            self.interactivePopGestureRecognizer.delegate = nil;
            self.interactivePopGestureRecognizer.enabled = NO;
            
            if (![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.screenPanGesture]) {
                [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.screenPanGesture];
                self.screenPanGesture.delegate = self.popGestureDelegate;
            }
        }else {
            self.interactivePopGestureRecognizer.delaysTouchesBegan = YES;
            self.interactivePopGestureRecognizer.delegate = self.popGestureDelegate;
            self.interactivePopGestureRecognizer.enabled = !isRootVC;
        }
    }else {
        self.interactivePopGestureRecognizer.delegate = nil;
        self.interactivePopGestureRecognizer.enabled = NO;
        [self.interactivePopGestureRecognizer.view removeGestureRecognizer:self.screenPanGesture];
        
        if (!isRootVC && ![self.interactivePopGestureRecognizer.view.gestureRecognizers containsObject:self.panGesture]) {
            [self.interactivePopGestureRecognizer.view addGestureRecognizer:self.panGesture];
            self.panGesture.delegate = self.popGestureDelegate;
        }
        if (self.lz_translationScale || self.lz_openScrollLeftPush) {
            [self.panGesture addTarget:self.navDelegate action:@selector(panGestureAction:)];
        }else {
            
            SEL internalAction = NSSelectorFromString(@"handleNavigationTransition:");
            [self.panGesture addTarget:[self systemTarget] action:internalAction];
        }
    }
}

- (void)lz_pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    // 设置默认值
    if (self.viewControllers.count > 0) {
        // 设置返回按钮
        if ([viewController isKindOfClass:[LZNavigationBarViewController class]]) {
//            LZNavigationBarViewController *vc = (LZNavigationBarViewController *)viewController;
            
//            UIImage *backImage = self.visibleViewController.lz_backStyle == LZNavigationBarBackStyleBlack ? LZImage(@"btn_back_black") : LZImage(@"btn_back_white");
//            vc.lz_navLeftBarButtonItem = [UIBarButtonItem itemWithTitle:nil image:backImage target:self action:@selector(goBack)];
        }
    }
    
    if (![self.viewControllers containsObject:viewController]) {
        [self lz_pushViewController:viewController animated:animated];
    }
}

- (void)goBack {
    [self popViewControllerAnimated:YES];
}

#pragma mark - StatusBar
- (BOOL)prefersStatusBarHidden {
    return self.visibleViewController.lz_StatusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return self.visibleViewController.lz_statusBarStyle;
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return self.visibleViewController;
}

- (UIViewController *)childViewControllerForStatusBarStyle {
    
    YYLog(@"%zd", self.visibleViewController.preferredStatusBarStyle);
    
    return self.visibleViewController;
}

#pragma mark - getter
- (BOOL)lz_translationScale {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (BOOL)lz_openScrollLeftPush {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (LZPopGestureRecognizerDelegate *)popGestureDelegate {
    LZPopGestureRecognizerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [LZPopGestureRecognizerDelegate new];
        delegate.navigationController = self;
        delegate.systemTarget         = [self systemTarget];
        delegate.customTarget         = self.navDelegate;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (LZNavigationControllerDelegate *)navDelegate {
    LZNavigationControllerDelegate *delegate = objc_getAssociatedObject(self, _cmd);
    if (!delegate) {
        delegate = [LZNavigationControllerDelegate new];
        delegate.navigationController = self;
        delegate.pushDelegate         = self;
        
        objc_setAssociatedObject(self, _cmd, delegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return delegate;
}

- (UIScreenEdgePanGestureRecognizer *)screenPanGesture {
    UIScreenEdgePanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self.navDelegate action:@selector(panGestureAction:)];
        panGesture.edges = UIRectEdgeLeft;
        
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (UIPanGestureRecognizer *)panGesture {
    UIPanGestureRecognizer *panGesture = objc_getAssociatedObject(self, _cmd);
    if (!panGesture) {
        panGesture = [[UIPanGestureRecognizer alloc] init];
        panGesture.maximumNumberOfTouches = 1;
        
        objc_setAssociatedObject(self, _cmd, panGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return panGesture;
}

- (id)systemTarget {
    NSArray *internalTargets = [self.interactivePopGestureRecognizer valueForKey:@"targets"];
    id internalTarget = [internalTargets.firstObject valueForKey:@"target"];
    
    return internalTarget;
}

#pragma mark - setter
- (void)setLz_translationScale:(BOOL)lz_translationScale {
    objc_setAssociatedObject(self, @selector(lz_translationScale), @(lz_translationScale), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setLz_openScrollLeftPush:(BOOL)lz_openScrollLeftPush {
    objc_setAssociatedObject(self, @selector(lz_openScrollLeftPush), @(lz_openScrollLeftPush), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - LZViewControllerScrollPushDelegate
- (void)pushNext {
    // 获取当前控制器
    UIViewController *currentVC = self.visibleViewController;
    
    if ([currentVC.lz_pushDelegate respondsToSelector:@selector(pushToNextViewController)]) {
        [currentVC.lz_pushDelegate pushToNextViewController];
    }
}

@end
