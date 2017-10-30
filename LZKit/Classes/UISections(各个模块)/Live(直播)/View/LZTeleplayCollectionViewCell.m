//
//  LZTeleplayCollectionViewCell.m
//  LZKit
//
//  Created by 寕小陌 on 2017/9/4.
//  Copyright © 2017年 cara. All rights reserved.
//

#import "LZTeleplayCollectionViewCell.h"

@interface LZTeleplayCollectionViewCell ()

@property (nonatomic, strong) IBOutlet UILabel *teleplayTitle;   // 电视剧标题
@property (nonatomic, strong) IBOutlet UILabel *teleplaysynopsis;// 电视剧简介
@property (nonatomic, strong) IBOutlet UIImageView *coverImageView;  // 电视剧封面图

@end

@implementation LZTeleplayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_coverImageView lz_setCornerRadius:5];
}

-(void)setType:(NSInteger)type{
    _type = type;
    CGFloat height = self.lz_width*9/16;
    if (type == 1) {
        height = self.lz_width*4/3;
    }
    self.recomandInageViewHeightConstraint.constant = height;
    [self layoutIfNeeded];
    
    NSString *image = @"";
    NSString *imagePlaceOlder = @"";
    if (self.type == 0) {//大图
        image = @"http://182.138.102.131:8080/App2/Images/2017/09/03/1.jpg";
        imagePlaceOlder = @"BIGBITMAP";
    }else if (self.type == 1){//横图
        image = @"http://182.138.102.131:8080/App2/Images/2017/09/03/4.jpg";
        imagePlaceOlder = @"VERTICALMAPBITMAP";
    }else if (self.type == 3){//竖图
        image = @"http://182.138.102.131:8080/App2/Images/2017/09/03/4_1.jpg";
        imagePlaceOlder = @"CROSSMAPBITMAP";
    }
//    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:image]
//                           placeholderImage:[UIImage imageNamed:imagePlaceOlder]];
}

- (void) setTitle:(NSString *)title{

//    _teleplayTitle.text = [NSString stringWithFormat:@"%@(%@)",_teleplayTitle.text,title];
}

- (void) setResultData:(NSDictionary *)resultData {
    
    _resultData = resultData;
    _teleplayTitle.text = _resultData[@"expand"][@"title"];
    _teleplaysynopsis.text = _resultData[@"expand"][@"synopsis"];
//    [_coverImageView sd_setImageWithURL:_resultData[@"expand"][@"advertiseImageL"] placeholderImage:nil];
//    [self initView];
}

@end
