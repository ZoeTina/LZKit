//
//  LZDelegateHandler.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/17.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZDelegateHandler.h"
#import "UIViewController+LZExtension.h"
#import "UINavigationController+LZCategory.h"
#import "LZPushTransitionAnimation.h"
#import "LZPopTransitionAnimation.h"

@implementation LZPopGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer {
    
    // 忽略跟控制器
    if (self.navigationController.viewControllers.count <= 1) {
        return NO;
    }
    
    // 忽略禁用手势
    UIViewController *topVC = self.navigationController.viewControllers.lastObject;
    if (topVC.lz_interactivePopDisabled) {
        return NO;
    }
    
    CGPoint transition = [gestureRecognizer translationInView:gestureRecognizer.view];
    
    SEL action = NSSelectorFromString(@"handleNavigationTransition:");
    
    if (transition.x < 0) {
        if (self.navigationController.lz_openScrollLeftPush) {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        }else {
            return NO;
        }
    }else {
        // 上下滑动
        if (transition.x == 0) return NO;
        
        // 忽略超出手势区域
        CGPoint beginningLocation = [gestureRecognizer locationInView:gestureRecognizer.view];
        CGFloat maxAllowDistance  = topVC.lz_popMaxAllowedDistanceToLeftEdge;
        if (maxAllowDistance > 0 && beginningLocation.x > maxAllowDistance) {
            return NO;
        }else if(!self.navigationController.lz_translationScale) { // 非缩放，系统处理
            [gestureRecognizer removeTarget:self.customTarget action:@selector(panGestureAction:)];
            [gestureRecognizer addTarget:self.systemTarget action:action];
        }else {
            [gestureRecognizer removeTarget:self.systemTarget action:action];
            [gestureRecognizer addTarget:self.customTarget action:@selector(panGestureAction:)];
        }
    }
    
    // 忽略导航控制器正在做转场动画
    if ([[self.navigationController valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    
    return YES;
}

@end

@interface LZNavigationControllerDelegate()

@property (nonatomic, assign) BOOL isGesturePush;

// push动画的百分比
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *pushTransition;

// pop动画的百分比
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *popTransition;

@end

@implementation LZNavigationControllerDelegate

#pragma mark - UINavigationControllerDelegate
- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    
    if ((self.navigationController.lz_translationScale) || (self.navigationController.lz_openScrollLeftPush && self.pushTransition)) {
        if (operation == UINavigationControllerOperationPush) {
            return [LZPushTransitionAnimation lz_transitionWithScale:self.navigationController.lz_translationScale];
        }else if (operation == UINavigationControllerOperationPop) {
            return [LZPopTransitionAnimation lz_transitionWithScale:self.navigationController.lz_translationScale];
        }
    }
    
    return nil;
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    if ((self.navigationController.lz_translationScale) || (self.navigationController.lz_openScrollLeftPush && self.pushTransition)) {
        
        if ([animationController isKindOfClass:[LZPopTransitionAnimation class]]) {
            return self.popTransition;
        }else if ([animationController isKindOfClass:[LZPushTransitionAnimation class]]) {
            return self.pushTransition;
        }
    }
    
    return nil;
}

#pragma mark - 滑动手势处理
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    // 进度
    CGFloat progress    = [gesture translationInView:gesture.view].x / gesture.view.bounds.size.width;
    CGPoint translation = [gesture velocityInView:gesture.view];
    
    // 在手势开始的时候判断是push操作还是pop操作
    if (gesture.state == UIGestureRecognizerStateBegan) {
        self.isGesturePush = translation.x < 0 ? YES : NO;
    }
    
    // push时 progress < 0 需要做处理
    if (self.isGesturePush) {
        progress = -progress;
    }
    
    progress = MIN(1.0, MAX(0.0, progress));
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        if (self.isGesturePush) {
            if (self.navigationController.lz_openScrollLeftPush && [self.pushDelegate respondsToSelector:@selector(pushNext)]) {
                self.pushTransition = [UIPercentDrivenInteractiveTransition new];
                self.pushTransition.completionCurve = UIViewAnimationCurveEaseOut;
                
                [self.pushDelegate pushNext];
                
                [self.pushTransition updateInteractiveTransition:0];
            }
        }else {
            self.popTransition = [UIPercentDrivenInteractiveTransition new];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }else if (gesture.state == UIGestureRecognizerStateChanged) {
        if (self.isGesturePush) {
            if (self.navigationController.lz_openScrollLeftPush) {
                [self.pushTransition updateInteractiveTransition:progress];
            }
        }else {
            [self.popTransition updateInteractiveTransition:progress];
        }
    }else if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
        if (self.isGesturePush) {
            if (self.navigationController.lz_openScrollLeftPush) {
                if (progress > 0.5) {
                    [self.pushTransition finishInteractiveTransition];
                }else {
                    [self.pushTransition cancelInteractiveTransition];
                }
            }
        }else {
            if (progress > 0.5) {
                [self.popTransition finishInteractiveTransition];
            }else {
                [self.popTransition cancelInteractiveTransition];
            }
        }
        self.pushTransition = nil;
        self.popTransition  = nil;
        self.isGesturePush  = NO;
    }
}

@end
