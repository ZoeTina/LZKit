//
//  UIViewController+LZSemiModel.h
//  LZKit
//
//  Created by 寕小陌 on 2017/8/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

@interface NSObject (LZOptionsAndDefaults)
- (void)lz_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults;
- (id)lz_optionOrDefaultForKey:(NSString*)optionKey;
@end
//==================================================================================================


//
// Convenient category method to find actual ViewController that contains a view
//
@interface UIView (FindUIViewController)
- (UIViewController *) lz_containingViewController;
- (id) lz_traverseResponderChainForUIViewController;
@end
//==================================================================================================


//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModelDidShowNotification @"kSemiModelDidShowNotification"
#define kSemiModelDidHideNotification @"kSemiModelDidHideNotification"
#define kSemiModelWasResizedNotification @"kSemiModelWasResizedNotification"

extern const struct LZSemiModelOptionKeys {
	__unsafe_unretained NSString *traverseParentHierarchy; // boxed BOOL. default is YES.
	__unsafe_unretained NSString *pushParentBack;		   // boxed BOOL. default is YES.
	__unsafe_unretained NSString *animationDuration; // boxed double, in seconds. default is 0.5.
	__unsafe_unretained NSString *parentAlpha;       // boxed float. lower is darker. default is 0.5.
    __unsafe_unretained NSString *parentScale;       // boxed double default is 0.8
	__unsafe_unretained NSString *shadowOpacity;     // default is 0.8
	__unsafe_unretained NSString *transitionStyle;	 // boxed NSNumber - one of the KNSemiModalTransitionStyle values.
    __unsafe_unretained NSString *disableCancel;     // boxed BOOL. default is NO.
    __unsafe_unretained NSString *backgroundView;     // UIView, custom background.
} LZSemiModelOptionKeys;



typedef void (^LZTransitionCompletionBlock)(void);

@interface UIViewController (LZSemiModel)

/**
 Displays a view controller over the receiver, which is "dimmed".
 @param vc           The view controller to display semi-modally; its view's frame height is used.
 @param options	     See LZSemiModelOptionKeys constants.
 @param completion   Is called after `-[vc viewDidAppear:]`.
 @param dismissBlock Is called when the user dismisses the semi-modal view by tapping the dimmed receiver view.
 */
-(void)lz_presentSemiViewController:(UIViewController*)vc
                        withOptions:(NSDictionary*)options
                         completion:(LZTransitionCompletionBlock)completion
                       dismissBlock:(LZTransitionCompletionBlock)dismissBlock;

-(void)lz_presentSemiView:(UIView*)view
              withOptions:(NSDictionary*)options
               completion:(LZTransitionCompletionBlock)completion;

// Convenient overloading methods
-(void)lz_presentSemiViewController:(UIViewController*)vc;
-(void)lz_presentSemiViewController:(UIViewController*)vc withOptions:(NSDictionary*)options;
-(void)lz_presentSemiView:(UIView*)vc;
-(void)lz_presentSemiView:(UIView*)view withOptions:(NSDictionary*)options;

// Update (refresh) backgroundView
-(void)lz_updateBackground;
// Dismiss & resize
-(void)lz_resizeSemiView:(CGSize)newSize;
-(void)lz_dismissSemiModalView;
-(void)lz_dismissSemiModalViewWithCompletion:(LZTransitionCompletionBlock)completion;

@end
