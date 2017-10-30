//
//  LZHomeViewModel.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZHomeViewModel.h"

@implementation LZHomeViewModel

- (NSMutableArray *)getModelData {
    NSMutableArray *dataArray=[NSMutableArray arrayWithObjects:
                               @"李白",@"王昭君",@"太乙真人",@"曹操",@"安琪拉",@"亚瑟",@"狄仁杰",
                               @"花木兰",@"钟馗",@"甄姬",@"诸葛亮",@"李元芳",@"阿珂",@"程咬金",
                               @"兰陵王",@"大桥",@"露娜",@"娜可露露",@"不知火舞",@"凯",@"老夫子",
                               @"小乔",@"庄周",@"张飞",@"蔡文姬",@"孙悟空",@"鲁班七号",@"刘备",
                               @"后羿", @"马可波罗",@"成吉思汗",@"虞姬",@"吕布",@"#",@"高渐离",
                               @"#百里守约",@"#百里玄策",
                               nil];

    /*
    self.titles = @[].mutableCopy;
    self.classNames = @[].mutableCopy;
    [self addCell:@"竖屏GIF播放" class:@""];
    [self addCell:@"全屏GIF播放" class:@""];
    [self addCell:@"头像选择" class:@""];
    [self addCell:@"弹窗效果" class:@""];
    [self addCell:@"拆分GIF" class:@""];
    [self addCell:@"广播音频动画" class:@""];*/
    return dataArray;
}


- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

@end
