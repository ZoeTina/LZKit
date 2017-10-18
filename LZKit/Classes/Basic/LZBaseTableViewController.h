//
//  LZBaseTableViewController.h
//  LZKit
//
//  Created by Ensem on 2017/10/18.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZBaseTableViewController : UITableViewController

@property (nonatomic,assign) BOOL isLogin;
@property (nonatomic,strong) NSArray *itemModelArray;
@property (nonatomic,strong) UIButton *footView;


@end
