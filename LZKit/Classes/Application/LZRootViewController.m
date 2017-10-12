//
//  LZRootViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/12.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZRootViewController.h"

@interface LZRootViewController ()<UITabBarControllerDelegate>

@end

@implementation LZRootViewController

+ (void)initialize {
    
    // 默认字体颜色及选择字体颜色
    //-------------------------------------------------------------------------------------------------------------------------------------------------
    NSMutableDictionary *textAttrs=[NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = kColorWithRGB(121, 125, 130);
    
    
    NSMutableDictionary *selectedTextAttrs=[NSMutableDictionary dictionaryWithDictionary:textAttrs];
    selectedTextAttrs[NSForegroundColorAttributeName] = kColorWithRGB(0,189,39);
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:10];
    [tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:selectedTextAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 添加所有子控制器
    [self addAllChildVc];
}

/**
 *  添加所有的子控制器
 */
- (void)addAllChildVc {
    
    UIViewController *vc1 = [[UIViewController alloc] init];
    vc1.view.backgroundColor = kColorWithRGB(233, 233, 233);
    
    UIViewController *vc2 = [[UIViewController alloc] init];
    vc2.view.backgroundColor = kColorWithRGB(123, 123, 123);
    
    UIViewController *vc3 = [[UIViewController alloc] init];
    vc3.view.backgroundColor = kColorWithRGB(111, 11, 11);
    
    UIViewController *vc4 = [[UIViewController alloc] init];
    vc4.view.backgroundColor = kColorWithRGB(180, 180, 180);
    [self addOneChildVC:vc1
                  title:@"消息"
       normalImageNamed:@"tab_messages_nor"
      selectedImageName:@"tab_messages_press"];
    
    [self addOneChildVC:vc2
                  title:@"通讯录"
       normalImageNamed:@"tab_groups_nor"
      selectedImageName:@"tab_groups_press"];
    
    [self addOneChildVC:vc3
                  title:@"发现"
       normalImageNamed:@"tab_dynamic_nor"
      selectedImageName:@"tab_dynamic_press"];
    
    [self addOneChildVC:vc4
                  title:@"我"
       normalImageNamed:@"tab_me_nor"
      selectedImageName:@"tab_me_press"];
}

/**
 *  添加一个自控制器
 *
 *  @param childVc           子控制器对象
 *  @param title             标题
 *  @param normalImageNamed  图标
 *  @param selectedImageName 选中时的图标
 */

- (void)addOneChildVC:(UIViewController *)childVc title:(NSString *)title normalImageNamed:(NSString *)normalImageNamed selectedImageName:(NSString *)selectedImageName {
    // 设置标题
    childVc.tabBarItem.title = title;
    // 设置图标
    childVc.tabBarItem.image = [[UIImage imageNamed:normalImageNamed]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    // 设置选中的图标
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    // 声明显示图片的原始式样 不要渲染
    childVc.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    childVc.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -2);
    childVc.tabBarItem.imageInsets = UIEdgeInsetsZero;
    // 添加为tabbar控制器的子控制器
    LZNavigationController *navigation = [[LZNavigationController alloc] initWithRootViewController:childVc];
//    nav.delegate = self;
    [self addChildViewController:navigation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
