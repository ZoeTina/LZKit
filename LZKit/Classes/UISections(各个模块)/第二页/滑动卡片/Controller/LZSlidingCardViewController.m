//
//  LZSlidingCardViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/31.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZSlidingCardViewController.h"
#import "LZSlidingCardContainer.h"
#import "LZChildCardView.h"

#define curViewHeight self.view.lz_height - 49 - 64
#ifndef weakify
#if DEBUG
#if __has_feature(objc_arc)
#define weakify(object) autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) autoreleasepool{} __block __typeof__(object) block##_##object = object;
#endif
#else
#if __has_feature(objc_arc)
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#else
#define weakify(object) try{} @finally{} {} __block __typeof__(object) block##_##object = object;
#endif
#endif
#endif
@interface LZSlidingCardViewController ()<LZSlidingCardContainerDelegate, LZSlidingCardContainerDataSource>
@property (nonatomic, strong) LZSlidingCardContainer *container;

@end

@implementation LZSlidingCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self initUI];
}

#pragma mark ————— 创建UI界面 —————
-(void)initUI{
    // 创建 _container
    _container = [[LZSlidingCardContainer alloc]init];
    _container.frame = CGRectMake(0, 64, self.view.lz_width, curViewHeight);
    _container.backgroundColor = [UIColor clearColor];
    _container.dataSource = self;
    _container.delegate = self;
    //    _container.canSlidingDirection = LZSlidingDirectionLeft | LZSlidingDirectionRight | LZSlidingDirectionUp;
    [self.view addSubview:_container];
    
    // 创建上下左右四个按钮
    for (int i = 0; i < 4; i++) {
        
        UIView *view = [[UIView alloc]init];
        CGFloat size = self.view.lz_width / 4;
        view.frame = CGRectMake(size * i, curViewHeight - size, size, size);
        //        view.backgroundColor = [UIColor darkGrayColor];
        [self.view addSubview:view];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, size - 20, size - 20);
        [button setBackgroundColor:kColorWithRGB(211, 0, 0)];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont fontWithName:@"Futura-Medium" size:18];
        button.clipsToBounds = YES;
        button.layer.cornerRadius = button.lz_width / 2;
        button.tag = i;
        [button addTarget:self action:@selector(buttonTap:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:button];
        
        if (i == 0) { [button setTitle:@"上" forState:UIControlStateNormal]; }
        if (i == 1) { [button setTitle:@"下" forState:UIControlStateNormal]; }
        if (i == 2) { [button setTitle:@"左" forState:UIControlStateNormal]; }
        if (i == 3) { [button setTitle:@"右" forState:UIControlStateNormal]; }
    }
    
    // 获取数据
    [self loadData];
    
    // 给_container赋值
    [_container lz_reloadCardContainer];
    
}


- (void)loadData
{
    _dataModelArray = [NSMutableArray array];
    
    for (int i = 0; i < 20; i++) {
        NSDictionary *dict = @{@"image" : [NSString stringWithFormat:@"photo_sample_0%d",i%7 + 1],
                               @"name" : @"LZSlidingCardContainer Demo"};
        [_dataModelArray addObject:dict];
    }
}

#pragma mark -- Selector
- (void)buttonTap:(UIButton *)button
{
    if (button.tag == 0) {
        [_container lz_movePositionWithDirection:LZSlidingDirectionUp isAutomatic:YES];
    }
    if (button.tag == 1) {
        @weakify(self);
        [_container lz_movePositionWithDirection:LZSlidingDirectionDown isAutomatic:YES undoHandler:^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@""
                                                                                     message:@"Do you want to reset?"
                                                                              preferredStyle:UIAlertControllerStyleAlert];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                [weak_self.container lz_movePositionWithDirection:LZSlidingDirectionDown isAutomatic:YES];
            }]];
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [weak_self.container lz_movePositionWithDirection:LZSlidingDirectionDefault isAutomatic:YES];
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }];
        
    }
    if (button.tag == 2) {
        [_container lz_movePositionWithDirection:LZSlidingDirectionLeft isAutomatic:YES];
    }
    if (button.tag == 3) {
        [_container lz_movePositionWithDirection:LZSlidingDirectionRight isAutomatic:YES];
    }
}

#pragma mark -- LZSlidingCardContainer dataModelArrayource
// 根据index获取当前的view
- (UIView *)lz_cardContainerViewNextViewWithIndex:(NSInteger)index
{
    NSDictionary *dict = _dataModelArray[index];
    LZChildCardView *view = [[LZChildCardView alloc]initWithFrame:CGRectMake(10, 10, self.view.lz_width - 20, self.view.lz_width - 20)];
    view.backgroundColor = [UIColor whiteColor];
    view.imageView.image = [UIImage imageNamed:dict[@"image"]];
    view.label.text = [NSString stringWithFormat:@"%@  %ld",dict[@"name"],(long)index];
    return view;
}

// 获取view的个数
- (NSInteger)lz_cardContainerViewNumberOfViewInIndex:(NSInteger)index
{
    return _dataModelArray.count;
}

#pragma mark -- LZSlidingCardContainer Delegate
// 滑动view结束后调用这个方法
- (void)lz_cardContainerView:(LZSlidingCardContainer *)cardContainerView didEndDraggingAtIndex:(NSInteger)index draggableView:(UIView *)draggableView draggableDirection:(LZSlidingDirection)draggableDirection
{
    if (draggableDirection == LZSlidingDirectionLeft) {
        [cardContainerView lz_movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == LZSlidingDirectionRight) {
        [cardContainerView lz_movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == LZSlidingDirectionUp) {
        [cardContainerView lz_movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
    
    if (draggableDirection == LZSlidingDirectionDown) {
        [cardContainerView lz_movePositionWithDirection:draggableDirection
                                         isAutomatic:NO];
    }
}

// 更新view的状态, 滑动中会调用这个方法
- (void)lz_cardContainderView:(LZSlidingCardContainer *)cardContainderView updatePositionWithSlidingView:(UIView *)slidingView slidingDirection:(LZSlidingDirection)slidingDirection widthRatio:(CGFloat)widthRatio heightRatio:(CGFloat)heightRatio
{
    LZChildCardView *view = (LZChildCardView *)slidingView;
    
    if (slidingDirection == LZSlidingDirectionDefault) {
        view.selectedView.alpha = 0;
    }
    
    if (slidingDirection == LZSlidingDirectionLeft) {
        view.selectedView.backgroundColor = kColorWithRGB(211, 0, 0);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (slidingDirection == LZSlidingDirectionRight) {
        view.selectedView.backgroundColor = kColorWithRGB(215, 215, 215);
        view.selectedView.alpha = widthRatio > 0.8 ? 0.8 : widthRatio;
    }
    
    if (slidingDirection == LZSlidingDirectionUp) {
        view.selectedView.backgroundColor = kColorWithRGB(104, 104, 104);
        view.selectedView.alpha = heightRatio > 0.8 ? 0.8 : heightRatio;
    }
}


// 所有卡片拖动完成后调用这个方法
- (void)cardContainerViewDidCompleteAll:(LZSlidingCardContainer *)container;
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.3 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [container lz_reloadCardContainer];
    });
}


// 点击view调用这个
- (void)lz_cardContainerView:(LZSlidingCardContainer *)cardContainerView didSelectAtIndex:(NSInteger)index draggableView:(UIView *)draggableView
{
    YYLog(@"++ index : %ld",(long)index);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
