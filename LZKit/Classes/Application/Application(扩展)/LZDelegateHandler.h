//
//  LZDelegateHandler.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <Foundation/Foundation.h>
// 左滑push代理
@protocol LZViewControllerScrollPushDelegate <NSObject>

- (void)pushNext;

@end

@class LZNavigationControllerDelegate;
// 此类用于处理UIGestureRecognizerDelegate的代理方法

@interface LZPopGestureRecognizerDelegate : NSObject<UIGestureRecognizerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

// 系统返回手势的target
@property (nonatomic, strong) id systemTarget;

@property (nonatomic, strong) LZNavigationControllerDelegate *customTarget;

@end
// 此类用于处理UINavigationControllerDelegate的代理方法
@interface LZNavigationControllerDelegate : NSObject<UINavigationControllerDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;

@property (nonatomic, weak) id<LZViewControllerScrollPushDelegate> pushDelegate;

// 手势Action
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture;

@end
