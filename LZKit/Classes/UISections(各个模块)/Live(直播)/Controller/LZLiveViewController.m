//
//  LZLiveViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/30.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZLiveViewController.h"
#import "LZTeleplayCollectionViewCell.h"
#import "LZRecommandCollectionViewCell.h"
#import "LZRecommandReusableView.h"

static NSString *CellIdentifier = @"LZTeleplayCollectionViewCell";
static NSString *resuIdentifier = @"LZRecommandCollectionViewCell";
static NSString *resuReusableView = @"LZRecommandReusableView";

@interface LZLiveViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic) UICollectionView *collectionView;

@end

@implementation LZLiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self createCollectionView];
}

- (void)createCollectionView {
    CGFloat itemWidth  = (kScreenWidth-13*2)/2.0;
    //    CGFloat itemHeight = itemWidth/3.0*2;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(14, 11, 14, 11);
    flowLayout.minimumInteritemSpacing = 1;//设置列与列之间的间距最小距离
    flowLayout.minimumLineSpacing      = 14;//设置行与行之间的间距最小距离
    flowLayout.itemSize = CGSizeMake(itemWidth, 144);//设置每个item的大小
    
    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, YYScreenWidth, YYScreenHeight-64) collectionViewLayout:flowLayout];
//    if (kiPhoneX) {
//        self.collectionView.lz_height = YYScreenHeight-54-34*2;
//    }
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate   = self;
    [self.collectionView registerNib:[UINib nibWithNibName:resuReusableView bundle:nil]
          forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                 withReuseIdentifier:resuReusableView];
    [self.collectionView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
          forCellWithReuseIdentifier:CellIdentifier];
    [self.collectionView registerNib:[UINib nibWithNibName:resuIdentifier bundle:nil]
          forCellWithReuseIdentifier:resuIdentifier];

    [self.view addSubview:self.collectionView];
}

#pragma mark -
#pragma mark UICollectionView代理
#pragma mark <UICollectionViewDataSource>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == 0) {
        return 2;
    }else if (section == 1) {
        return 3;
    }
    return 100;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 3;
}
//设置每个一个Item（cell）的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //每个item也可以调成不同的大小
    CGFloat width = kScreenWidth-20;
    CGFloat height = width*9/16;
    CGFloat margin = 60;
    CGFloat itemWidth  = (kScreenWidth-13*2)/2.0;

    if (indexPath.section == 1) {
        width = (collectionView.lz_width-30)/3.0;
        height = collectionView.lz_width*9/16;
        return CGSizeMake(width,height);
    }else if (indexPath.section == 2) {
        width = (collectionView.lz_width-30)*0.5;
        height = width*9/16 + margin;
        return CGSizeMake(itemWidth,height);
    }
    return CGSizeMake(width,height);
}

//设置所有的cell组成的视图与section 上、左、下、右的间隔
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,10,10,10);
}

//设置footer呈现的size, 如果布局是垂直方向的话，size只需设置高度，宽与collectionView一致
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section{
    YYLog(@"section -- %ld",(long)section);
    if (!section) {
        return CGSizeMake(kScreenWidth,10);
    }else if(section == 1){
        return CGSizeMake(kScreenWidth,10);
    }
    return CGSizeMake(kScreenWidth,0.01);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        LZRecommandCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:resuIdentifier forIndexPath:indexPath];
        return cell;
    }
    LZTeleplayCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.title = self.title;
    if(indexPath.section==1){
        cell.type = 1;
    }else if (indexPath.section==2){
        cell.type = 2;
    }
    return cell;
}
/*
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    LZRecommandReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:resuReusableView forIndexPath:indexPath];

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 1) {
            //        headerView.type = 2;
            headerView.titleLabel.text = @"精彩合集";
        }
        
        headerView.hidden = false;
        if (indexPath.section == 0){
            headerView.hidden = true;
        }
        return headerView;
    }
    headerView.hidden = true;
    return headerView;
}*/

#pragma mark <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    YYLog(@" 点击的电视剧是 -- %ld",(long)indexPath.row);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
