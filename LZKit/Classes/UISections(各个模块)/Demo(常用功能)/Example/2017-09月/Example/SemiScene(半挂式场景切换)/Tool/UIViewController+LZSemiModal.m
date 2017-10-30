//
//  LZSemiModelViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/8/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "UIViewController+LZSemiModal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

const struct LZSemiModelOptionKeys LZSemiModelOptionKeys = {
	.traverseParentHierarchy = @"LZSemiModelOptionTraverseParentHierarchy",
	.pushParentBack          = @"LZSemiModelOptionPushParentBack",
	.animationDuration       = @"LZSemiModelOptionAnimationDuration",
    .parentAlpha             = @"LZSemiModelOptionParentAlpha",
    .parentScale             = @"LZSemiModelOptionParentScale",
	.shadowOpacity           = @"LZSemiModelOptionShadowOpacity",
	.transitionStyle         = @"LZSemiModelTransitionStyle",
    .disableCancel           = @"LZSemiModelOptionDisableCancel",
    .backgroundView          = @"LZSemiModelOptionBackgroundView",
};

#define kSemiModelViewController           @"PaPQC93kjgzUanz"
#define kSemiModelDismissBlock             @"l27h7RU2dzVfPoQ"
#define kSemiModelPresentingViewController @"QKWuTQjUkWaO1Xr"
#define kSemiModelOverlayTag               10001
#define kSemiModelScreenshotTag            10002
#define kSemiModelViewTag                  10003
#define kSemiModelDismissButtonTag         10004


NS_ENUM(NSUInteger, LZSemiModelTransitionStyle) {
    LZSemiModelTransitionStyleSlideUp = 0,
    LZSemiModelTransitionStyleFadeInOut,
    LZSemiModelTransitionStyleFadeIn,
    LZSemiModelTransitionStyleFadeOut
};

@interface UIViewController (LZSemiModelInternal)
-(UIView*)lz_parentTarget;
-(CAAnimationGroup*)lz_animationGroupForward:(BOOL)_forward;
@end

@implementation UIViewController (LZSemiModelInternal)

-(UIViewController*)lz_parentTargetViewController {
	UIViewController * target = self;
	if ([[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.traverseParentHierarchy] boolValue]) {
		// cover UINav & UITabbar as well
		while (target.parentViewController != nil) {
			target = target.parentViewController;
		}
	}
	return target;
}
-(UIView*)lz_parentTarget {
    return [self lz_parentTargetViewController].view;
}

#pragma mark Options and defaults

-(void)lz_registerDefaultsAndOptions:(NSDictionary*)options {
	[self lz_registerOptions:options defaults:@{
     LZSemiModelOptionKeys.traverseParentHierarchy : @(YES),
     LZSemiModelOptionKeys.pushParentBack : @(YES),
     LZSemiModelOptionKeys.animationDuration : @(0.5),
     LZSemiModelOptionKeys.parentAlpha : @(0.5),
     LZSemiModelOptionKeys.parentScale : @(0.8),
     LZSemiModelOptionKeys.shadowOpacity : @(0.8),
     LZSemiModelOptionKeys.transitionStyle : @(LZSemiModelTransitionStyleSlideUp),
     LZSemiModelOptionKeys.disableCancel : @(NO),
	 }];
}

#pragma mark Push-back animation group

-(CAAnimationGroup*)lz_animationGroupForward:(BOOL)_forward {
    // Create animation keys, forwards and backwards
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // The rotation angle is minor as the view is nearer
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    double scale = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.parentScale] doubleValue];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // Minor shift to mantai perspective
        t2 = CATransform3DTranslate(t2, 0, [self lz_parentTarget].lz_height*-0.04, 0);
        t2 = CATransform3DScale(t2, scale, scale, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, [self lz_parentTarget].lz_height*-0.08, 0);
        t2 = CATransform3DScale(t2, scale, scale, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.animationDuration] doubleValue];
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

-(void)lz_interfaceOrientationDidChange:(NSNotification*)notification {
	UIView *overlay = [[self lz_parentTarget] viewWithTag:kSemiModelOverlayTag];
	[self lz_addOrUpdateParentScreenshotInView:overlay];
}

-(UIImageView*)lz_addOrUpdateParentScreenshotInView:(UIView*)screenshotContainer {
	UIView *target = [self lz_parentTarget];
	UIView *semiView = [target viewWithTag:kSemiModelViewTag];
	
	screenshotContainer.hidden = YES; // screenshot without the overlay!
	semiView.hidden = YES;
	UIGraphicsBeginImageContextWithOptions(target.bounds.size, YES, [[UIScreen mainScreen] scale]);
    if ([target respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [target drawViewHierarchyInRect:target.bounds afterScreenUpdates:YES];
    } else {
        [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	screenshotContainer.hidden = NO;
	semiView.hidden = NO;
	
	UIImageView* screenshot = (id) [screenshotContainer viewWithTag:kSemiModelScreenshotTag];
	if (screenshot) {
		screenshot.image = image;
	}
	else {
		screenshot = [[UIImageView alloc] initWithImage:image];
		screenshot.tag = kSemiModelScreenshotTag;
		screenshot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[screenshotContainer addSubview:screenshot];
	}
	return screenshot;
}

@end

@implementation UIViewController (KNSemiModal)

-(void)lz_presentSemiViewController:(UIViewController*)vc {
	[self lz_presentSemiViewController:vc withOptions:nil completion:nil dismissBlock:nil];
}
-(void)lz_presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options {
    [self lz_presentSemiViewController:vc withOptions:options completion:nil dismissBlock:nil];
}
-(void)lz_presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options
					  completion:(LZTransitionCompletionBlock)completion
					dismissBlock:(LZTransitionCompletionBlock)dismissBlock {
    [self lz_registerDefaultsAndOptions:options]; // re-registering is OK
	UIViewController *targetParentVC = [self lz_parentTargetViewController];

	// implement view controller containment for the semi-modal view controller
	[targetParentVC addChildViewController:vc];
	if ([vc respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[vc beginAppearanceTransition:YES animated:YES]; // iOS 6
	}
	objc_setAssociatedObject(self, kSemiModelViewController, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kSemiModelDismissBlock, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self lz_presentSemiView:vc.view withOptions:options completion:^{
		[vc didMoveToParentViewController:targetParentVC];
		if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
			[vc endAppearanceTransition]; // iOS 6
		}
		if (completion) {
			completion();
		}
	}];
}

-(void)lz_presentSemiView:(UIView*)view {
	[self lz_presentSemiView:view withOptions:nil completion:nil];
}
-(void)lz_presentSemiView:(UIView*)view withOptions:(NSDictionary*)options {
	[self lz_presentSemiView:view withOptions:options completion:nil];
}
-(void)lz_presentSemiView:(UIView*)view
              withOptions:(NSDictionary*)options
               completion:(LZTransitionCompletionBlock)completion {
	[self lz_registerDefaultsAndOptions:options]; // re-registering is OK
	UIView * target = [self lz_parentTarget];
	
    if (![target.subviews containsObject:view]) {
        // Set associative object
        objc_setAssociatedObject(view, kSemiModelPresentingViewController, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        // Register for orientation changes, so we can update the presenting controller screenshot
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(lz_interfaceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        // Get transition style
        NSUInteger transitionStyle = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.transitionStyle] unsignedIntegerValue];
        
        // Calulate all frames
        CGFloat semiViewHeight = view.frame.size.height;
        CGRect vf = target.bounds;
        CGRect semiViewFrame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // We center the view and mantain aspect ration
            semiViewFrame = CGRectMake((vf.size.width - view.frame.size.width) / 2.0, vf.size.height-semiViewHeight, view.frame.size.width, semiViewHeight);
        } else {
            semiViewFrame = CGRectMake(0, vf.size.height-semiViewHeight, vf.size.width, semiViewHeight);
        }
        
        CGRect overlayFrame = CGRectMake(0, 0, vf.size.width, vf.size.height-semiViewHeight);
        
        // Add semi overlay
        UIView *overlay;
        UIView *backgroundView = [self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.backgroundView];
        if (backgroundView) {
            overlay = backgroundView;
        } else {
            overlay = [[UIView alloc] init];
        }
        
        overlay.frame = target.bounds;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.userInteractionEnabled = YES;
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlay.tag = kSemiModelOverlayTag;
        
        // Take screenshot and scale
        UIImageView *ss = [self lz_addOrUpdateParentScreenshotInView:overlay];
        [target addSubview:overlay];
        
        // Dismiss button (if allow)
        if(![[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.disableCancel] boolValue]) {
            // Don't use UITapGestureRecognizer to avoid complex handling
            UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dismissButton addTarget:self action:@selector(lz_dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
            dismissButton.backgroundColor = [UIColor clearColor];
            dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            dismissButton.frame = overlayFrame;
            dismissButton.tag = kSemiModelDismissButtonTag;
            [overlay addSubview:dismissButton];
        }
        
        // Begin overlay animation
		if ([[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.pushParentBack] boolValue]) {
			[ss.layer addAnimation:[self lz_animationGroupForward:YES] forKey:@"pushedBackAnimation"];
		}
		NSTimeInterval duration = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.animationDuration] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            ss.alpha = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.parentAlpha] floatValue];
        }];
        
        // Present view animated
        view.frame = (transitionStyle == LZSemiModelTransitionStyleSlideUp
                      ? CGRectOffset(semiViewFrame, 0, +semiViewHeight)
                      : semiViewFrame);
        if (transitionStyle == LZSemiModelTransitionStyleFadeIn || transitionStyle == LZSemiModelTransitionStyleFadeInOut) {
            view.alpha = 0.0;
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // Don't resize the view width on rotating
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        } else {
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        }
        
        view.tag = kSemiModelViewTag;
        [target addSubview:view];
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, -2);
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOpacity = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.shadowOpacity] floatValue];
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        [UIView animateWithDuration:duration animations:^{
            if (transitionStyle == LZSemiModelTransitionStyleSlideUp) {
                view.frame = semiViewFrame;
            } else if (transitionStyle == LZSemiModelTransitionStyleFadeIn || transitionStyle == LZSemiModelTransitionStyleFadeInOut) {
                view.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            if (!finished) return;
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModelDidShowNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }];
    }
}
-(void)updateBackground{
    UIView *target = [self lz_parentTarget];
    UIView *overlay = [target viewWithTag:kSemiModelOverlayTag];
    [self lz_addOrUpdateParentScreenshotInView:overlay];
}
-(void)lz_dismissSemiModalView {
	[self lz_dismissSemiModelViewWithCompletion:nil];
}

-(void)lz_dismissSemiModelViewWithCompletion:(void (^)(void))completion {
    // Look for presenting controller if available
    UIViewController *prstingTgt = self;
    UIViewController *presentingController = objc_getAssociatedObject(prstingTgt.view, kSemiModelPresentingViewController);
    while (presentingController == nil && prstingTgt.parentViewController != nil) {
        prstingTgt = prstingTgt.parentViewController;
        presentingController = objc_getAssociatedObject(prstingTgt.view, kSemiModelPresentingViewController);
    }
    if (presentingController) {
        objc_setAssociatedObject(presentingController.view, kSemiModelPresentingViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [presentingController lz_dismissSemiModelViewWithCompletion:completion];
        return;
    }

    // Correct target for dismissal
    UIView * target = [self lz_parentTarget];
    UIView * modal = [target viewWithTag:kSemiModelViewTag];
    UIView * overlay = [target viewWithTag:kSemiModelOverlayTag];
	NSUInteger transitionStyle = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.transitionStyle] unsignedIntegerValue];
	NSTimeInterval duration = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.animationDuration] doubleValue];
	UIViewController *vc = objc_getAssociatedObject(self, kSemiModelViewController);
	LZTransitionCompletionBlock dismissBlock = objc_getAssociatedObject(self, kSemiModelDismissBlock);
	
	// Child controller containment
	[vc willMoveToParentViewController:nil];
	if ([vc respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[vc beginAppearanceTransition:NO animated:YES]; // iOS 6
	}
	
    [UIView animateWithDuration:duration animations:^{
        if (transitionStyle == LZSemiModelTransitionStyleSlideUp) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                // As the view is centered, we perform a vertical translation
                modal.frame = CGRectMake((target.bounds.size.width - modal.frame.size.width) / 2.0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
            } else {
                modal.frame = CGRectMake(0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
            }
        } else if (transitionStyle == LZSemiModelTransitionStyleFadeOut || transitionStyle == LZSemiModelTransitionStyleFadeInOut) {
            modal.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
        
        // Child controller containment
        [vc removeFromParentViewController];
        if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
            [vc endAppearanceTransition];
        }
        
        if (dismissBlock) {
            dismissBlock();
        }
        
        objc_setAssociatedObject(self, kSemiModelDismissBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, kSemiModelViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }];
    
    // Begin overlay animation
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
	if ([[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.pushParentBack] boolValue]) {
		[ss.layer addAnimation:[self lz_animationGroupForward:NO] forKey:@"bringForwardAnimation"];
	}
    [UIView animateWithDuration:duration animations:^{
        ss.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModelDidHideNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)lz_resizeSemiView:(CGSize)newSize {
    UIView * target = [self lz_parentTarget];
    UIView * modal = [target viewWithTag:kSemiModelViewTag];
    CGRect mf = modal.frame;
    mf.size.width = newSize.width;
    mf.size.height = newSize.height;
    mf.origin.y = target.frame.size.height - mf.size.height;
    UIView * overlay = [target viewWithTag:kSemiModelOverlayTag];
    UIButton * button = (UIButton*)[overlay viewWithTag:kSemiModelDismissButtonTag];
    CGRect bf = button.frame;
    bf.size.height = overlay.frame.size.height - newSize.height;
	NSTimeInterval duration = [[self lz_optionOrDefaultForKey:LZSemiModelOptionKeys.animationDuration] doubleValue];
	[UIView animateWithDuration:duration animations:^{
        modal.frame = mf;
        button.frame = bf;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModelWasResizedNotification
                                                                object:self];
        }
    }];
}

@end



#pragma mark - NSObject (LZOptionsAndDefaults)

//  NSObject+LZOptionsAndDefaults
//  Created by 寕小陌 on 08.10.12.
//  Copyright (c) 2012 寕小陌. All rights reserved.
#import <objc/runtime.h>

@implementation NSObject (LZOptionsAndDefaults)

static char const * const kLZStandardOptionsTableName = "LZStandardOptionsTableName";
static char const * const kLZStandardDefaultsTableName = "LZStandardDefaultsTableName";

- (void)lz_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults
{
	objc_setAssociatedObject(self, kLZStandardOptionsTableName, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kLZStandardDefaultsTableName, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)lz_optionOrDefaultForKey:(NSString*)optionKey
{
	NSDictionary *options = objc_getAssociatedObject(self, kLZStandardOptionsTableName);
	NSDictionary *defaults = objc_getAssociatedObject(self, kLZStandardDefaultsTableName);
	NSAssert(defaults, @"Defaults must have been set when accessing options.");
	return options[optionKey] ?: defaults[optionKey];
}
@end



#pragma mark - UIView (FindUIViewController)

// Convenient category method to find actual ViewController that contains a view

@implementation UIView (FindUIViewController)
- (UIViewController *) lz_containingViewController {
    UIView * target = self.superview ? self.superview : self;
    return (UIViewController *)[target lz_traverseResponderChainForUIViewController];
}

- (id) lz_traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    BOOL isViewController = [nextResponder isKindOfClass:[UIViewController class]];
    BOOL isTabBarController = [nextResponder isKindOfClass:[UITabBarController class]];
    if (isViewController && !isTabBarController) {
        return nextResponder;
    } else if(isTabBarController){
        UITabBarController *tabBarController = nextResponder;
        return [tabBarController selectedViewController];
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder lz_traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
