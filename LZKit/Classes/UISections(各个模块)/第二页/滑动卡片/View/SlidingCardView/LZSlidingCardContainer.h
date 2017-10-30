//
//  LZSlidingCardContainer.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/31.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZSlidingCardContainer;

typedef NS_OPTIONS(NSInteger, LZSlidingDirection) {
    LZSlidingDirectionDefault     = 0,      // 0
    LZSlidingDirectionLeft        = 1 << 0, // 1
    LZSlidingDirectionRight       = 1 << 1, // 2
    LZSlidingDirectionUp          = 1 << 2, // 4
    LZSlidingDirectionDown        = 1 << 3  // 8
};


@protocol LZSlidingCardContainerDataSource <NSObject>

- (UIView *)lz_cardContainerViewNextViewWithIndex:(NSInteger)index;
- (NSInteger)lz_cardContainerViewNumberOfViewInIndex:(NSInteger)index;

@end

@protocol LZSlidingCardContainerDelegate <NSObject>

- (void)lz_cardContainerView:(LZSlidingCardContainer *)cardContainerView
       didEndSlidingAtIndex:(NSInteger)index
                 slidingView:(UIView *)slidingView
            slidingDirection:(LZSlidingDirection)slidingDirection;

@optional
- (void)lz_cardContainerViewDidCompleteAll:(LZSlidingCardContainer *)container;

- (void)lz_cardContainerView:(LZSlidingCardContainer *)cardContainerView
            didSelectAtIndex:(NSInteger)index
                 slidingView:(UIView *)slidingView;

- (void)lz_cardContainderView:(LZSlidingCardContainer *)cardContainderView updatePositionWithSlidingView:(UIView *)slidingView slidingDirection:(LZSlidingDirection)slidingDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio;

@end

@interface LZSlidingCardContainer : UIView

/**
 *  default is LZSlidingDirectionLeft | LZSlidingDirectionRight
 */
@property (nonatomic, assign) LZSlidingDirection canSlidingDirection;
@property (nonatomic, weak) id <LZSlidingCardContainerDataSource> dataSource;
@property (nonatomic, weak) id <LZSlidingCardContainerDelegate> delegate;

/**
 *  reloads everything from scratch. redisplays card.
 */
- (void)lz_reloadCardContainer;

- (void)lz_movePositionWithDirection:(LZSlidingDirection)direction isAutomatic:(BOOL)isAutomatic;
- (void)lz_movePositionWithDirection:(LZSlidingDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)(void))undoHandler;

- (UIView *)lz_getCurrentView;
@end
