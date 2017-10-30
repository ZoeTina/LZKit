//
//  CMNewFeaturesController.m
//  CMKit
//
//  Created by HC on 16/11/7.
//  Copyright © 2016年 UTOUU. All rights reserved.
//

#import "CMNewFeaturesController.h"

@interface CMNewFeaturesController () <UIScrollViewDelegate>

/** ScrollView */
@property (strong , nonatomic) UIScrollView *scrollView;

/** PageControl */
@property (strong , nonatomic) UIPageControl *pageControl;

@end

@implementation CMNewFeaturesController

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        // 创建UI
        [self initUI];
    }
    return self;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;

    //  配置UI
    [self configUI];
}


#pragma mark - 创建UI控件
- (void)initUI {
    
    // 创建scrollView
    [self createScrollView];
    
    // 创建pageControl
    [self createPageControl];
    
    // 创建关联UI
    [self createExperienceBtn];
    self.featuresArray = @[@"welcome_guide_1_new@2x.png",
                           @"welcome_guide_2_new@2x.png",
                           @"welcome_guide_3_new@2x.png"].mutableCopy;
}

//创建立即体验Btn
- (void)createExperienceBtn {
    UIButton *experienceBtn = [UIButton lz_initWithFrame:self.view.bounds
                                                   title:@"立即体验"
                                         backgroundImage:[UIImage lz_imageWithColor:kColorWithRGB(173, 25, 64)]
                              highlightedBackgroundImage:[UIImage lz_imageWithColor:kColorWithRGB(135, 17, 49)]];
//    UIButton *experienceBtn = [[UIButton alloc] init];
    self.experienceBtn = experienceBtn;
//    [experienceBtn setTitle:@"退出新特性 >" forState:UIControlStateNormal];
//    experienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
//    [experienceBtn setBackgroundImage:[UIImage lz_imageWithColor:kColorWithRGB(173, 25, 64)] forState:UIControlStateNormal];
//    [experienceBtn setBackgroundImage:[UIImage lz_imageWithColor:kColorWithRGB(135, 17, 49)] forState:UIControlStateHighlighted];
    [experienceBtn addTarget:self action:@selector(experienceBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

//创建PageControl
- (void)createPageControl {
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    self.pageControl = pageControl;
    pageControl.pageIndicatorTintColor = kColorWithRGB(133, 128, 127);
    pageControl.currentPageIndicatorTintColor = kColorWithRGB(171, 11, 66);
}


//创建scrollView
- (void)createScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    self.scrollView = scrollView;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.frame = self.view.bounds;
    scrollView.pagingEnabled = YES;

    
}

#pragma mark - 配置UI
- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self configScrollViewFrame];
    if (self.featuresArray.count > 1) {
        [self configPageControlFrame];
    }
    [self configAssociatedUIFrame];
    
}

// 配置pageControl
- (void)configScrollViewFrame
{
    self.scrollView.contentSize = CGSizeMake(kScreenWidth * self.featuresArray.count,kScreenHeight);
    [self.view addSubview:self.scrollView];
}


// 配置pageControl
- (void)configPageControlFrame
{
    
    self.pageControl.numberOfPages = self.featuresArray.count;
    self.pageControl.currentPageIndicatorTintColor = self.currentPageIndicatorTintColor;
    self.pageControl.pageIndicatorTintColor = self.pageIndicatorTintColor;
    
    
    CGFloat pageControlW = 100;
    CGFloat pageControlH = 20;
    CGFloat pageControlX = (kScreenWidth - pageControlW) / 2 ;
    CGFloat pageControlY = kScreenHeight - 30 - pageControlH;
    self.pageControl.frame = CGRectMake(pageControlX, pageControlY, pageControlW, pageControlH);
    [self.view addSubview:self.pageControl];
    
}

// 配置关联UI
- (void)configAssociatedUIFrame {
    
    
    for (int i = 0; i<self.featuresArray.count; i++) {
        
        //1.创建imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageStr = [NSString stringWithFormat:@"%@",self.featuresArray[i]];
        imageView.image = [UIImage imageNamed:imageStr];
        
        CGFloat imageViewX = i * kScreenWidth;
        CGFloat imageViewY = 0;
        CGFloat imageViewW = kScreenWidth;
        CGFloat imageViewH = kScreenHeight;
        
        imageView.frame = CGRectMake(imageViewX, imageViewY, imageViewW, imageViewH);
        
        [self.scrollView addSubview:imageView];
        
        
        //2.在ScrollView中最后一张添加“立即体验”按钮
        if (i == (self.featuresArray.count - 1)) {
            [self configExperienceBtn:(int)(self.featuresArray.count - 1)];
        }
    }
}

/** 设置立即体验按钮 */
- (void)configExperienceBtn:(int)i
{
    CGFloat experienceBtnX = 20 + kScreenWidth * i;
    CGFloat experienceBtnW = kScreenWidth - 2 * 20;
    CGFloat experienceBtnH = 40;
    CGFloat experienceBtnY;
    
    if ([[UIDevice lz_devicePlatformString] isEqualToString:@"iPhone 4S"]) {//iPhone 4/4s
        experienceBtnY = kScreenHeight - 50 - experienceBtnH - 20;
    }else{//iPhone 5以上屏幕
        experienceBtnY = kScreenHeight - 50 - experienceBtnH - 30;
    }
    
    self.experienceBtn.frame = CGRectMake(experienceBtnX, experienceBtnY, experienceBtnW, experienceBtnH);
    [self.experienceBtn lz_setCornerRadius:experienceBtnH/2];

    [self.scrollView addSubview:self.experienceBtn];
    
}

#pragma mark - 按钮事件
/** 立即体验按钮事件 */
- (void)experienceBtnClick
{
    if (self.experienceBtnBlock) {
        self.experienceBtnBlock();
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //设置pageControl的currentPage属性
    CGFloat doublePage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    int pageNumber = (int)(doublePage + 0.5);
    self.pageControl.currentPage = pageNumber;
    
}


@end
