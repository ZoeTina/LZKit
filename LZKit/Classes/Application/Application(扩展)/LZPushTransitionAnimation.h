//
//  LZPushTransitionAnimation.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/18.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZPushTransitionAnimation : NSObject<UIViewControllerAnimatedTransitioning>

+ (instancetype)lz_transitionWithScale:(BOOL)scale;

@end
