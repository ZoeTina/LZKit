//
//  LZTeleplayCollectionViewCell.h
//  LZKit
//
//  Created by 寕小陌 on 2017/9/4.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZTeleplayCollectionViewCell : UICollectionViewCell

//- (id)initWithDictionary:(NSDictionary *)dictionary;
@property (nonatomic, strong) NSDictionary *resultData;            // 数据数组
@property (nonatomic, strong) NSString *title;           

///控制照片的显示模式和比例
@property(nonatomic, assign)NSInteger type;
///照片的高约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *recomandInageViewHeightConstraint;
@end
