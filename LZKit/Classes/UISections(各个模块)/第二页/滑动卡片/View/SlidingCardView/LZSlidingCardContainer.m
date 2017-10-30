//
//  LZSlidingCardContainer.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/31.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZSlidingCardContainer.h"

static const CGFloat kPreloadViewCount = 3.0f;
static const CGFloat kSecondCard_Scale = 0.96f;
static const CGFloat kTherdCard_Scale = 0.92f;
static const CGFloat kCard_Margin = 14.0f;
static const CGFloat kSlidingCompleteCoefficient_width_default = 0.8f;
static const CGFloat kSlidingCompleteCoefficient_height_default = 0.6f;
static const CGFloat kCard_Sliding_Speed = 900.0f;//拖动速度

typedef NS_ENUM(NSInteger, LZMoveSlope) {  // 触摸点是上还是下
    LZMoveSlopeTop = 1,
    LZMoveSlopeBottom = -1
};

@interface LZSlidingCardContainer ()

@property (nonatomic, assign) LZMoveSlope moveSlope;
@property (nonatomic, assign) CGRect defaultFrame;
@property (nonatomic, assign) CGFloat cardCenterX; // 视图中心点X值
@property (nonatomic, assign) CGFloat cardCenterY; // 视图中心点Y值
@property (nonatomic, assign) NSInteger loadedIndex;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSMutableArray *currentViews;
@property (nonatomic, assign) BOOL isInitialAnimation;

@end

@implementation LZSlidingCardContainer

- (id)init
{
    self = [super init];
    if (self) {
        [self setUp];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cardViewTap:)];
        [self addGestureRecognizer:tapGesture];
        
        _canSlidingDirection = LZSlidingDirectionLeft | LZSlidingDirectionRight;
    }
    return self;
}

- (void)setUp
{
    _moveSlope = LZMoveSlopeTop;
    _loadedIndex = 0.0f;
    _currentIndex = 0.0f;
    _currentViews = [NSMutableArray array];
}

#pragma mark -- Public

-(void)lz_reloadCardContainer
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    [_currentViews removeAllObjects];
    _currentViews = [NSMutableArray array];
    [self setUp];
    [self loadNextView];
    _isInitialAnimation = NO;
    [self viewInitialAnimation];
}

- (void)lz_movePositionWithDirection:(LZSlidingDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
{
    [self lz_cardViewDirectionAnimation:direction isAutomatic:isAutomatic undoHandler:undoHandler];
}

- (void)lz_movePositionWithDirection:(LZSlidingDirection)direction isAutomatic:(BOOL)isAutomatic
{
    [self lz_cardViewDirectionAnimation:direction isAutomatic:isAutomatic undoHandler:nil];
}

- (UIView *)lz_getCurrentView
{
    return [_currentViews firstObject];
}

#pragma mark -- Private

- (void)loadNextView
{
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(lz_cardContainerViewNumberOfViewInIndex:)]) {
        NSInteger index = [self.dataSource lz_cardContainerViewNumberOfViewInIndex:_loadedIndex];
        YYLog(@"index = %zd, _loadedIndex = %zd, _currentIndex = %zd", index, _loadedIndex, _currentIndex);
        
        // all cardViews Dragging end
        if (index != 0 && index == _currentIndex) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(lz_cardContainerViewDidCompleteAll:)]) {
                [self.delegate lz_cardContainerViewDidCompleteAll:self];
            }
            return;
        }
        
        // load next cardView
        if (_loadedIndex < index) {
            
            NSInteger preloadViewCont = index <= kPreloadViewCount ? index : kPreloadViewCount;
            
            for (NSInteger i = _currentViews.count; i < preloadViewCont; i++) {
                if (self.dataSource && [self.dataSource respondsToSelector:@selector(lz_cardContainerViewNextViewWithIndex:)]) {
                    UIView *view = [self.dataSource lz_cardContainerViewNextViewWithIndex:_loadedIndex];
                    if (view) {
                        _defaultFrame = view.frame;
                        _cardCenterX = view.center.x;
                        _cardCenterY = view.center.y;
                        
                        [self addSubview:view];
                        [self sendSubviewToBack:view];
                        [_currentViews addObject:view];
                        
                        if (i == 1 && _currentIndex != 0) {
                            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
                        }
                        
                        if (i == 2 && _currentIndex != 0) {
                            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
                            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
                        }
                        _loadedIndex++;
                    }
                    
                }
            }
        }
        
        UIView *view = [self lz_getCurrentView];
        if (view) {
            UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
            [view addGestureRecognizer:gesture];
        }
    }
}
- (void)lz_cardViewDirectionAnimation:(LZSlidingDirection)direction isAutomatic:(BOOL)isAutomatic undoHandler:(void (^)())undoHandler
{
    if (!_isInitialAnimation) { return; }
    UIView *view = [self lz_getCurrentView];
    if (!view) { return; }
    
    __weak LZSlidingCardContainer *weakself = self;
    if (direction == LZSlidingDirectionDefault) {
        view.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.55
                              delay:0.0
             usingSpringWithDamping:0.6
              initialSpringVelocity:0.0
                            options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             view.frame = _defaultFrame;
                             
                             [weakself cardViewDefaultScale];
                         } completion:^(BOOL finished) {
                         }];
        
        return;
    }
    
    if (!undoHandler) {
        [_currentViews removeObject:view];
        _currentIndex++;
        [self loadNextView];
    }
    
    if (direction == LZSlidingDirectionRight || direction == LZSlidingDirectionLeft || direction == LZSlidingDirectionDown) {
        
        [UIView animateWithDuration:0.35
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             if (direction == LZSlidingDirectionLeft) {
                                 view.center = CGPointMake(-1 * (weakself.frame.size.width), view.center.y);
                                 
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformMakeRotation(-1 * M_PI_4);
                                 }
                             }
                             
                             if (direction == LZSlidingDirectionRight) {
                                 view.center = CGPointMake((weakself.frame.size.width * 2), view.center.y);
                                 
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformMakeRotation(direction * M_PI_4);
                                 }
                             }
                             
                             if (direction == LZSlidingDirectionDown) {
                                 view.center = CGPointMake(view.center.x, (weakself.frame.size.height * 1.5));
                             }
                             
                             if (!undoHandler) {
                                 [weakself cardViewDefaultScale];
                             }
                         } completion:^(BOOL finished) {
                             if (!undoHandler) {
                                 [view removeFromSuperview];
                             } else  {
                                 if (undoHandler) { undoHandler(); }
                             }
                         }];
    }
    
    if (direction == LZSlidingDirectionUp) {
        [UIView animateWithDuration:0.15
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             if (direction == LZSlidingDirectionUp) {
                                 if (isAutomatic) {
                                     view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.03,0.97);
                                     view.center = CGPointMake(view.center.x, view.center.y + kCard_Margin);
                                 }
                             }
                             
                         } completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.35
                                                   delay:0.0
                                                 options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  view.center = CGPointMake(view.center.x, -1 * ((weakself.frame.size.height) / 2));
                                                  [weakself cardViewDefaultScale];
                                              } completion:^(BOOL finished) {
                                                  if (!undoHandler) {
                                                      [view removeFromSuperview];
                                                  } else  {
                                                      if (undoHandler) { undoHandler(); }
                                                  }
                                              }];
                         }];
    }
}

- (void)cardViewUpDateScale
{
    UIView *view = [self lz_getCurrentView];
    
    float ratio_w = fabs((view.center.x - _cardCenterX) / _cardCenterX);
    float ratio_h = fabs((view.center.y - _cardCenterY) / _cardCenterY);
    float ratio = ratio_w > ratio_h ? ratio_w : ratio_h;
    
    if (_currentViews.count == 2) {
        if (ratio <= 1) {
            UIView *view = _currentViews[1];
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
        }
    }
    if (_currentViews.count == 3) {
        if (ratio <= 1) {
            {
                UIView *view = _currentViews[1];
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)),kSecondCard_Scale + (ratio * (1 - kSecondCard_Scale)));
            }
            {
                UIView *view = _currentViews[2];
                view.transform = CGAffineTransformIdentity;
                view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + ((kCard_Margin * 2) - (ratio * kCard_Margin)), _defaultFrame.size.width, _defaultFrame.size.height);
                view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)),kTherdCard_Scale + (ratio * (kSecondCard_Scale - kTherdCard_Scale)));
            }
        }
    }
}

- (void)cardViewDefaultScale
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(lz_cardContainderView:updatePositionWithSlidingView:slidingDirection:widthRatio:heightRatio:)]) {
        
        [self.delegate lz_cardContainderView:self updatePositionWithSlidingView:[self lz_getCurrentView]
                       slidingDirection:LZSlidingDirectionDefault
                               widthRatio:0 heightRatio:0];
    }
    
    for (int i = 0; i < _currentViews.count; i++) {
        UIView *view = _currentViews[i];
        if (i == 0) {
            view.transform = CGAffineTransformIdentity;
            view.frame = _defaultFrame;
        }
        if (i == 1) {
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + kCard_Margin, _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kSecondCard_Scale,kSecondCard_Scale);
        }
        if (i == 2) {
            view.transform = CGAffineTransformIdentity;
            view.frame = CGRectMake(_defaultFrame.origin.x, _defaultFrame.origin.y + (kCard_Margin * 2), _defaultFrame.size.width, _defaultFrame.size.height);
            view.transform = CGAffineTransformScale(CGAffineTransformIdentity,kTherdCard_Scale,kTherdCard_Scale);
        }
    }
}

- (void)viewInitialAnimation
{
    for (UIView *view in _currentViews) {
        view.alpha = 0.0;
    }
    
    UIView *view = [self lz_getCurrentView];
    if (!view) { return; }
    __weak LZSlidingCardContainer *weakself = self;
    view.alpha = 1.0;
    view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.5f,0.5f);
    [UIView animateWithDuration:0.1
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.05f,1.05f);
                     }
                     completion:^(BOOL finished){
                         [UIView animateWithDuration:0.1
                                               delay:0.0
                                             options:UIViewAnimationOptionCurveEaseOut
                                          animations:^{
                                              view.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.95f,0.95f);
                                          }
                                          completion:^(BOOL finished) {
                                              [UIView animateWithDuration:0.1
                                                                    delay:0.0
                                                                  options:UIViewAnimationOptionCurveEaseOut
                                                               animations:^{
                                                                   view.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.0f,1.0f);
                                                               }
                                                               completion:^(BOOL finished) {
                                                                   
                                                                   for (UIView *view in _currentViews) {
                                                                       view.alpha = 1.0;
                                                                   }
                                                                   
                                                                   [UIView animateWithDuration:0.25f
                                                                                         delay:0.01f
                                                                                       options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                                                                                    animations:^{
                                                                                        [weakself cardViewDefaultScale];
                                                                                    } completion:^(BOOL finished) {
                                                                                        weakself.isInitialAnimation = YES;
                                                                                    }];
                                                               }
                                               ];
                                          }
                          ];
                     }
     ];
}

#pragma mark -- Gesture Selector

- (void)handlePanGesture:(UIPanGestureRecognizer *)gesture
{
    if (!_isInitialAnimation) { return; }
    if (gesture.state == UIGestureRecognizerStateBegan) {  // 1
        CGPoint touchPoint = [gesture locationInView:self];
        if (touchPoint.y <= _cardCenterY) {  // 一般往上滑动 手指触动的是下半部分
            _moveSlope = LZMoveSlopeTop;
        } else {
            _moveSlope = LZMoveSlopeBottom;
        }
    }
    
    if (gesture.state == UIGestureRecognizerStateChanged) { // 2
        
        CGPoint point = [gesture translationInView:self];
        CGPoint movedPoint = CGPointMake(gesture.view.center.x + point.x, gesture.view.center.y + point.y);
        YYLog(@"point.y  =%f, gesture.view.center.y = %f, movedPoint.y = %f", point.y, gesture.view.center.y, movedPoint.y);
        gesture.view.center = movedPoint;
        
        [gesture.view setTransform:
         CGAffineTransformMakeRotation((gesture.view.center.y - _cardCenterY) / _cardCenterY * (_moveSlope * (M_PI / 20)))];
        YYLog(@"scale = %f", (gesture.view.center.y - _cardCenterY) / _cardCenterY);
        YYLog(@"make = %f", (gesture.view.center.y - _cardCenterY) / _cardCenterY * (_moveSlope * (M_PI / 20)));
        
        [self cardViewUpDateScale];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(lz_cardContainderView:updatePositionWithSlidingView:slidingDirection:widthRatio:heightRatio:)]) {
            if ([self lz_getCurrentView]) {
                
                float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
                float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
                
                LZSlidingDirection direction = LZSlidingDirectionDefault;
                
                if (fabs(ratio_h) > fabs(ratio_w)) {  // Q:判断方向, 这种方法好吗?
                    
                    if (ratio_h <= 0) {
                        // up
                        if (_canSlidingDirection & LZSlidingDirectionUp) {
                            direction = LZSlidingDirectionUp;
                        } else {
                            direction = ratio_w <= 0 ? LZSlidingDirectionLeft : LZSlidingDirectionRight;
                        }
                    } else {
                        // down
                        if (_canSlidingDirection & LZSlidingDirectionDown) {
                            direction = LZSlidingDirectionDown;
                        } else {
                            direction = ratio_w <= 0 ? LZSlidingDirectionLeft : LZSlidingDirectionRight;
                        }
                    }
                    
                } else {
                    if (ratio_w <= 0) {
                        // left
                        if (_canSlidingDirection & LZSlidingDirectionLeft) {
                            direction = LZSlidingDirectionLeft;
                        } else {
                            direction = ratio_h <= 0 ? LZSlidingDirectionUp : LZSlidingDirectionDown;
                        }
                    } else {
                        // right
                        if (_canSlidingDirection & LZSlidingDirectionRight) {
                            direction = LZSlidingDirectionRight;
                        } else {
                            direction = ratio_h <= 0 ? LZSlidingDirectionUp : LZSlidingDirectionDown;
                        }
                    }
                    
                }
                
                [self.delegate lz_cardContainderView:self updatePositionWithSlidingView:gesture.view
                                    slidingDirection:direction
                                          widthRatio:fabs(ratio_w) heightRatio:fabsf(ratio_h)];
            }
        }
        
        CGPoint prePoint = [gesture translationInView:self];
        YYLog(@"前gesture.x = %f, gesture.y = %f", prePoint.x, prePoint.y);
        [gesture setTranslation:CGPointZero inView:self];
        CGPoint suffixPoint = [gesture translationInView:self];
        YYLog(@"后gesture.x = %f, gesture.y = %f", suffixPoint.x, suffixPoint.y);
        
    }
    
    if (gesture.state == UIGestureRecognizerStateEnded ||
        gesture.state == UIGestureRecognizerStateCancelled) {  // 3  4
        
        CGPoint velocity = [gesture velocityInView:gesture.view];
        YYLog(@"横向速度：%.f  纵向速度： %.f",velocity.x,velocity.y);
        YYLog(@"gesture.view.center.y = %f, _cardCenterY = %f", gesture.view.center.y , _cardCenterY);
        float ratio_w = (gesture.view.center.x - _cardCenterX) / _cardCenterX;
        float ratio_h = (gesture.view.center.y - _cardCenterY) / _cardCenterY;
        YYLog(@"ratio_w = %f, ratio_h = %f", ratio_w, ratio_h);
        
        LZSlidingDirection direction = LZSlidingDirectionDefault;
        if (fabs(ratio_h) > fabs(ratio_w)) {
            
            //            YYLog(@"_canSlidingDirection = %zd, LZSlidingDirectionDown = %zd", _canSlidingDirection, LZSlidingDirectionDown);
            //            YYLog(@"_canSlidingDirection & LZSlidingDirectionUp = %zd", _canSlidingDirection & LZSlidingDirectionUp);
            //            YYLog(@"kSlidingCompleteCoefficient_height_default = %f", kSlidingCompleteCoefficient_height_default);
            //            YYLog(@"kSlidingCompleteCoefficient_height_default && (_canSlidingDirection & LZSlidingDirectionDown) = %zd", kDragCompleteCoefficient_height_default && (_canSlidingDirection & LZSlidingDirectionDown));
            if (ratio_h < - kSlidingCompleteCoefficient_height_default && (_canSlidingDirection & LZSlidingDirectionUp)) {
                // up
                YYLog(@"_canSlidingDirection = %zd, LZSlidingDirectionUp = %zd", _canSlidingDirection, LZSlidingDirectionUp);
                YYLog(@"_canSlidingDirection & LZSlidingDirectionUp = %zd", _canSlidingDirection & LZSlidingDirectionUp);
                
                YYLog(@"ratio_h = %f, -kSlidingCompleteCoefficient_height_default = %f", ratio_h, -kSlidingCompleteCoefficient_height_default);
                direction = LZSlidingDirectionUp;
            }
            YYLog(@"ratio_h = %f, 与 = %d", ratio_h, kSlidingCompleteCoefficient_height_default && (_canSlidingDirection & LZSlidingDirectionDown));
            if (ratio_h > kSlidingCompleteCoefficient_height_default && !(_canSlidingDirection & LZSlidingDirectionDown)) {
                // down
                direction = LZSlidingDirectionDown;
            }
            
        }else {
            
            if ((ratio_w > kSlidingCompleteCoefficient_width_default || velocity.x>kCard_Sliding_Speed ) && (_canSlidingDirection & LZSlidingDirectionRight)) {
                // right
                direction = LZSlidingDirectionRight;
            }
            
            if ((ratio_w < - kSlidingCompleteCoefficient_width_default || velocity.x<-kCard_Sliding_Speed ) && (_canSlidingDirection & LZSlidingDirectionLeft)) {
                // left
                direction = LZSlidingDirectionLeft;
            }
        }
        
        if (direction == LZSlidingDirectionDefault) {
            [self lz_cardViewDirectionAnimation:LZSlidingDirectionDefault isAutomatic:NO undoHandler:nil];
        } else {
            if (self.delegate && [self.delegate respondsToSelector:@selector(lz_cardContainerView:didEndSlidingAtIndex:slidingView:slidingDirection:)]) {
                [self.delegate lz_cardContainerView:self didEndSlidingAtIndex:_currentIndex slidingView:gesture.view slidingDirection:direction];
            }
        }
    }
}

- (void)cardViewTap:(UITapGestureRecognizer *)gesture
{
    if (!_currentViews || _currentViews.count == 0) {
        return;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(lz_cardContainerView:didSelectAtIndex:slidingView:)]) {
        [self.delegate lz_cardContainerView:self didSelectAtIndex:_currentIndex slidingView:gesture.view];
    }
}
@end
