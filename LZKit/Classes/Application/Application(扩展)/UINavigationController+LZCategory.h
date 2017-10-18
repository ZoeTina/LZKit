//
//  UINavigationController+LZCategory.h
//  LZKit
//
//  Created by Ensem on 2017/10/18.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LZExtension.h"
#import "LZDelegateHandler.h"

@interface UINavigationController (LZCategory)<LZViewControllerScrollPushDelegate>

+ (instancetype)rootVC:(UIViewController *)rootVC translationScale:(BOOL)translationScale;

/** 导航栏转场时是否缩放,此属性只能在初始化导航栏的时候有效，在其他地方设置会导致错乱 */
@property (nonatomic, assign, readonly) BOOL lz_translationScale;

/** 是否开启左滑push操作，默认是NO */
@property (nonatomic, assign) BOOL lz_openScrollLeftPush;

@end

