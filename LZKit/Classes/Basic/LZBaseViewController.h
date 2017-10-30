//
//  LZBaseViewController.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/27.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZBaseViewController : UIViewController

/**
 *  仅当前控制器为UINavigationController的根控制器的时候才可使用这个方法
 */
- (void)useInteractivePopGestureRecognizer;

/**
 *  仅当前控制器是被UINavigationController push出来的时候才可使用这个属性
 */
@property (nonatomic)  BOOL  enableInteractivePopGestureRecognizer;

/**
 *  如果你的控制器是被一个UINavigationController管理，你可以使用这个方法去返回上一个控制器
 *
 *  @param animated Animated or not.是否需要返回动画
 */
- (void)popViewControllerAnimated:(BOOL)animated;

/**
 *  如果你的控制器是被一个UINavigationController管理，你可以使用这个方法返回根控制器
 *
 *  @param animated 是否需要返回动画
 */
- (void)popToRootViewControllerAnimated:(BOOL)animated;

@end
