//
//  LZNavigationController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/12.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZNavigationController.h"

@interface LZNavigationController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation LZNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UINavigationBar的主题
    [self setupNavigationBarTheme];
    self.popDelegate = self.interactivePopGestureRecognizer.delegate;
    self.delegate = self;
    // Do any additional setup after loading the view.
}

- (void) setupNavigationBarTheme {
    UIColor *BkColor = kColorWithRGB(211,0,0);

    // 1.去掉背景图片和底部线条
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];

    [self.navigationBar setBackgroundImage:[[LZNavigationController CreateImageWithColor:BkColor] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 1, 5, 1)] forBarMetrics:UIBarMetricsDefault];
    self.navigationBar.tintColor = [UIColor whiteColor];
    //去掉导航栏下边的投影
    self.navigationBar.shadowImage = [[LZNavigationController CreateImageWithColor:[UIColor clearColor]] resizableImageWithCapInsets:UIEdgeInsetsMake(1, 1, 1, 1)];
    
    self.navigationBar.barTintColor = kColorWithRGB(87, 87, 87);
    self.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationBar.translucent = NO;
    self.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

+ (UIImage *)CreateImageWithColor: (UIColor *) color{
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

- (void) pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
    if (self.viewControllers.count > 0) {
        self.interactivePopGestureRecognizer.enabled = YES;
        self.interactivePopGestureRecognizer.delegate = self;
        viewController.hidesBottomBarWhenPushed = YES;
        
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        
        // 设置导航栏的按钮
        UIBarButtonItem *backButton = [UIBarButtonItem lz_itemWithImageName:@"nav_back_copy"
                                                           highImageName:@"nav_back_copy"
                                                                  target:self
                                                                  action:@selector(back)];
        viewController.navigationItem.leftBarButtonItems = @[negativeSpacer, backButton];
        
        // 就有滑动返回功能
        self.interactivePopGestureRecognizer.delegate = nil;
        
    }
    [super pushViewController:viewController animated:animated];
}

// 加载完之后调用
- (void) navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    // 如果展示的控制器是根控制器,就还还原pop代理
    if (viewController == [self.viewControllers firstObject]) {
        self.interactivePopGestureRecognizer.delegate = self.popDelegate;
    }
}

- (void)back {
    // 判断两种情况: push 和 present
    if ((self.presentedViewController || self.presentingViewController) && self.childViewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
