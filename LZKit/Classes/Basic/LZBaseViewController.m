//
//  LZBaseViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/27.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZBaseViewController.h"

@interface LZBaseViewController ()

@end

@implementation LZBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor lz_colorWithHex:0xf2f2f2];
    self.automaticallyAdjustsScrollViewInsets = NO;
}


- (void)useInteractivePopGestureRecognizer{
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}


- (void)popViewControllerAnimated:(BOOL)animated{
    [self.navigationController popViewControllerAnimated:animated];
}


- (void)popToRootViewControllerAnimated:(BOOL)animated{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
