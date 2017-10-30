//
//  CMCommonSuperClassSampleController.m
//  CMKit
//
//  Created by HC on 16/11/7.
//  Copyright © 2016年 UTOUU. All rights reserved.
//

#import "CMCommonSuperClassSampleController.h"

@interface CMCommonSuperClassSampleController ()

@end

@implementation CMCommonSuperClassSampleController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initUI];
    
}
    
#pragma mark - 初始化UI
- (void)initUI{
    self.title = @"共用父类";
    
    UILabel *label = [UILabel lz_labelWithTitle:@"详细使用请看AppDelegate和CMCommonSuperClassSampleController类的使用"
                                          color:kColorWithRGB(211, 0, 0)
                                       fontSize:18.0f
                                      alignment:NSTextAlignmentLeft];
    label.frame = self.view.bounds;
    label.lz_height = kScreenHeight-64;
    [self.view addSubview:label];
}



@end
