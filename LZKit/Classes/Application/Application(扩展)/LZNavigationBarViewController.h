//
//  LZNavigationBarViewController.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZNavigationBarViewController : UIViewController

/** 自定义导航条 */
@property (nonatomic, strong, readonly) UINavigationBar     *lz_navigationBar;
/** 自定义导航栏栏目 */
@property (nonatomic, strong, readonly) UINavigationItem    *lz_navigationItem;

#pragma mark - 额外的快速设置导航栏的属性
@property (nonatomic, strong) UIColor   *lz_navBarTintColor;
/** 设置导航栏背景，[UIColor clearColor]可设置为透明 */
@property (nonatomic, strong) UIColor   *lz_navBackgroundColor;
@property (nonatomic, strong) UIImage   *lz_navBackgroundImage;
@property (nonatomic, strong) UIColor   *lz_navTintColor;
@property (nonatomic, strong) UIView    *lz_navTitleView;
@property (nonatomic, strong) UIColor   *lz_navTitleColor;
@property (nonatomic, strong) UIFont    *lz_navTitleFont;

@property (nonatomic, strong) UIBarButtonItem               *lz_navLeftBarButtonItem;
@property (nonatomic, strong) NSArray<UIBarButtonItem *>    *lz_navLeftBarButtonItems;

@property (nonatomic, strong) UIBarButtonItem               *lz_navRightBarButtonItem;
@property (nonatomic, strong) NSArray<UIBarButtonItem *>    *lz_navRightBarButtonItems;


/**
 显示导航栏分割线
 */
- (void)showNavLine;
/**
 隐藏导航栏分割线
 */
- (void)hideNavLine;

@end
