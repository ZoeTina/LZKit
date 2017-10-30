//
//  PVHomeInterractionCell.m
//  LZKit
//
//  Created by 寕小陌 on 17/8/31.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZRecommandCollectionViewCell.h"


@interface LZRecommandCollectionViewCell()
/** 封面 */
@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
/** 秒 */
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
/** 分 */
@property (weak, nonatomic) IBOutlet UILabel *middleTimeLabel;
/** 时 */
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;

@end
@implementation LZRecommandCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_coverImageView lz_setCornerRadius:5.0f];
    [_leftTimeLabel lz_setCornerRadius:3.0f];
    [_middleTimeLabel lz_setCornerRadius:3.0f];
    [_rightTimeLabel lz_setCornerRadius:3.0f];
    
}

@end
