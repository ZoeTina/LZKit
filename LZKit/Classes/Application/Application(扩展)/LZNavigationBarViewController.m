//
//  LZNavigationBarViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZNavigationBarViewController.h"
#import "LZNavigationBarConfigure.h"
#import "UIViewController+LZExtension.h"

@interface LZNavigationBarViewController ()

@property (nonatomic, strong) UINavigationBar   *lz_navigationBar;
@property (nonatomic, strong) UINavigationItem  *lz_navigationItem;

@end

@implementation LZNavigationBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置自定义导航栏
    [self setupCustomNavBar];
    
    // 设置导航栏外观
    [self setupNavBarAppearance];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.lz_navigationBar && !self.lz_navigationBar.hidden) {
        [self.view bringSubviewToFront:self.lz_navigationBar];
    }
}

#pragma mark - Public Methods
- (void)showNavLine {
    UIView *backgroundView = self.lz_navigationBar.subviews.firstObject;
    
    for (UIView *view in backgroundView.subviews) {
        if (view.frame.size.height < 1.0) {
            view.hidden = NO;
        }
    }
}

- (void)hideNavLine {
    UIView *backgroundView = self.lz_navigationBar.subviews.firstObject;
    
    for (UIView *view in backgroundView.subviews) {
        if (view.frame.size.height < 1.0) {
            view.hidden = YES;
        }
    }
}

#pragma mark - private Methods
/**
 设置自定义导航条
 */
- (void)setupCustomNavBar {
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.lz_navigationBar];
    self.lz_navigationBar.items = @[self.lz_navigationItem];
}

/**
 设置导航栏外观
 */
- (void)setupNavBarAppearance {
    
    LZNavigationBarConfigure *configure = [LZNavigationBarConfigure sharedInstance];
    
    if (configure.backgroundColor) {
        self.lz_navBackgroundColor = configure.backgroundColor;
    }
    
    if (configure.titleColor) {
        self.lz_navTitleColor = configure.titleColor;
    }
    
    if (configure.titleFont) {
        self.lz_navTitleFont = configure.titleFont;
    }
    
    self.lz_StatusBarHidden = configure.statusBarHidden;
    self.lz_statusBarStyle  = configure.statusBarStyle;
    
    self.lz_backStyle       = configure.backStyle;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
    CGFloat width  = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    // 导航栏高度：横屏(状态栏显示：52，状态栏隐藏：32) 竖屏64
    CGFloat navBarH = (width > height) ? (self.lz_StatusBarHidden ? 32 : 52) : (self.lz_StatusBarHidden ? 44 : 64);
    
    self.lz_navigationBar.frame = CGRectMake(0, 0, width, navBarH);
}

#pragma mark - 控制屏幕旋转的方法
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

#pragma mark - 懒加载
- (UINavigationBar *)lz_navigationBar {
    if (!_lz_navigationBar) {
        _lz_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    }
    return _lz_navigationBar;
}

- (UINavigationItem *)lz_navigationItem {
    if (!_lz_navigationItem) {
        _lz_navigationItem = [UINavigationItem new];
    }
    return _lz_navigationItem;
}

#pragma mark - setter
- (void)setTitle:(NSString *)title {
    self.lz_navigationItem.title = title;
}

- (void)setLz_navBarTintColor:(UIColor *)lz_navBarTintColor {
    _lz_navBarTintColor = lz_navBarTintColor;
    
    self.lz_navigationBar.barTintColor = lz_navBarTintColor;
}

- (void)setLz_navBackgroundColor:(UIColor *)lz_navBackgroundColor {
    _lz_navBackgroundColor = lz_navBackgroundColor;
    
    if (lz_navBackgroundColor == [UIColor clearColor]) {//LZImage(@"transparent_bg")
        [self.lz_navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.lz_navigationBar.shadowImage = [self imageWithColor:[UIColor clearColor]];
    }else {
        [self.lz_navigationBar setBackgroundImage:[self imageWithColor:lz_navBackgroundColor] forBarMetrics:UIBarMetricsDefault];
    }
}

- (void)setLz_navBackgroundImage:(UIImage *)lz_navBackgroundImage {
    _lz_navBackgroundImage = lz_navBackgroundImage;
    
    [self.lz_navigationBar setBackgroundImage:lz_navBackgroundImage forBarMetrics:UIBarMetricsDefault];
}

- (void)setLz_navTintColor:(UIColor *)lz_navTintColor {
    _lz_navTintColor = lz_navTintColor;
    
    self.lz_navigationBar.tintColor = lz_navTintColor;
}

- (void)setLz_navTitleView:(UIView *)lz_navTitleView {
    _lz_navTitleView = lz_navTitleView;
    
    self.lz_navigationItem.titleView = lz_navTitleView;
}

- (void)setLz_navTitleColor:(UIColor *)lz_navTitleColor {
    _lz_navTitleColor = lz_navTitleColor;
    
    UIFont *titleFont = self.lz_navTitleFont ? self.lz_navTitleFont : [LZNavigationBarConfigure sharedInstance].titleFont;
    
    self.lz_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: lz_navTitleColor, NSFontAttributeName: titleFont};
}

- (void)setLz_navTitleFont:(UIFont *)lz_navTitleFont {
    _lz_navTitleFont = lz_navTitleFont;
    
    UIColor *titleColor = self.lz_navTitleColor ? self.lz_navTitleColor : [LZNavigationBarConfigure sharedInstance].titleColor;
    
    self.lz_navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: titleColor, NSFontAttributeName: lz_navTitleFont};
}

- (void)setLz_navLeftBarButtonItem:(UIBarButtonItem *)lz_navLeftBarButtonItem {
    _lz_navLeftBarButtonItem = lz_navLeftBarButtonItem;
    
    self.lz_navigationItem.leftBarButtonItem = lz_navLeftBarButtonItem;
}

- (void)setLz_navLeftBarButtonItems:(NSArray<UIBarButtonItem *> *)lz_navLeftBarButtonItems {
    _lz_navLeftBarButtonItems = lz_navLeftBarButtonItems;
    
    self.lz_navigationItem.leftBarButtonItems = lz_navLeftBarButtonItems;
}

- (void)setLz_navRightBarButtonItem:(UIBarButtonItem *)lz_navRightBarButtonItem {
    _lz_navRightBarButtonItem = lz_navRightBarButtonItem;
    
    self.lz_navigationItem.rightBarButtonItem = lz_navRightBarButtonItem;
}

- (void)setLz_navRightBarButtonItems:(NSArray<UIBarButtonItem *> *)lz_navRightBarButtonItems {
    _lz_navRightBarButtonItems = lz_navRightBarButtonItems;
    
    self.lz_navigationItem.rightBarButtonItems = lz_navRightBarButtonItems;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1.0, 1.0)];
}

- (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
