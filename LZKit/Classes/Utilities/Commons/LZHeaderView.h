//
//  LZHeaderView.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/29.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZHeaderView : UITableViewHeaderFooterView

@property (nonatomic, copy) NSString *titleStr;

@property (nonatomic, assign) CGFloat hight;


/** 创建HeadView */
+ (instancetype)headView;

@end
