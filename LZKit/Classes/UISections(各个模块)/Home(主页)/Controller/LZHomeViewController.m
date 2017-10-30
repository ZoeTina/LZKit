//
//  LZHomeViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/18.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZHomeViewController.h"
#import "LZHomeTableViewCell.h"

static NSString *CellIdentifier = @"LZHomeTableViewCell";

@interface LZHomeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

/** 设置tableview */
@property (nonatomic, strong) UITableView           *lzTableView;
@property (nonatomic, strong) LZHomeTableViewCell   *lzCell;
@end

@implementation LZHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.lzTableView];
    [LZUtils lz_setExtraCellLineHidden:self.lzTableView];
    int64_t delayInSeconds = 0.1;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.titles = @[].mutableCopy;
        self.classNames = @[].mutableCopy;
        [self addCell:@"竖屏GIF播放" class:@""];
        [self addCell:@"全屏GIF播放" class:@""];
        [self addCell:@"头像选择" class:@""];
        [self addCell:@"弹窗效果" class:@""];
        [self addCell:@"拆分GIF" class:@""];
        [self addCell:@"广播音频动画" class:@""];
        [self.lzTableView reloadData];
    });
}

- (void)addCell:(NSString *)title class:(NSString *)className {
    [self.titles addObject:title];
    [self.classNames addObject:className];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titles.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    self.lzCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                  forIndexPath:indexPath];
    self.lzCell.titleLabel.text = _titles[indexPath.row];
    return self.lzCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *className = self.classNames[indexPath.row];
    Class class = NSClassFromString(className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = _titles[indexPath.row];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    [self.lzTableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void) dd{
    
    
    //    NSString *path = [[NSBundle mainBundle] pathForResource:@"TeleplayList" ofType:@"json"];
    //    NSData *data = [NSData dataWithContentsOfFile:path];
    //    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    //    NSArray *teleplayData = dict[@"data"];
    //    self.dataSource = teleplayData;
    
//    YYLog(@"PVScreeningBoxView ---3 --- %@",self.secondColumnModel.filter.area_detail);
    //        NSString *area_detail = self.secondColumnModel.filter.year_detail;
    //        NSArray *selectArr = [area_detail componentsSeparatedByString:@","];
    //
//    NSMutableArray *mb = [[NSMutableArray alloc] init];
    //        NSMutableArray *seArray = [[NSMutableArray alloc] init];
    //        for (int i=0;i<selectArr.count;i++) {
    //            [seArray addObject:selectArr[i]];
    //        }
    //
    //        // 年份
    //        NSString *year_detail = self.secondColumnModel.filter.year_detail;
    //        NSArray *yearArr = [year_detail componentsSeparatedByString:@","];
    //        NSMutableArray *seArray1 = [NSMutableArray new];
    //        for (int i=0;i<yearArr.count;i++) {
    //            [seArray1 addObject:selectArr[i]];
    //        }
    //
    //        // 年份
    //        NSString *videoMake_detail = self.secondColumnModel.filter.videoMake_detail;
    //        NSArray *videoMakeArr = [videoMake_detail componentsSeparatedByString:@","];
    //        NSMutableArray *seArray2 = [NSMutableArray new];
    //        for (int i=0;i<videoMakeArr.count;i++) {
    //            [seArray2 addObject:videoMakeArr[i]];
    //        }
    //
    //        // 年份
    //        NSString *hotOrNew_detail = self.secondColumnModel.filter.hotOrNew;
    //        NSArray *hotOrNewArr = [hotOrNew_detail componentsSeparatedByString:@","];
    //        NSMutableArray *seArray3 = [NSMutableArray new];
    //        for (int i=0;i<hotOrNewArr.count;i++) {
    //            [seArray3 addObject:hotOrNewArr[i]];
    //        }
    
//    _dictionary = [NSMutableDictionary new];
    NSDictionary *_dictionars;
    _dictionars = @{@"business":@[@[@"全部",@"爱情",@"爱古装",@"仙侠",@"剧情",@"都市"],
                                  @[@"全部",@"大陆",@"港台",@"台湾",@"韩国"],
                                  @[@"全部",@"2014年",@"2015年",@"2016年",@"2017年"],
                                  @[@"全部",@"最热",@"评分"],]};
    YYLog(@"mb - %@",_dictionars);
    
    //        [mb addObject:seArray2];
    //        [mb addObject:seArray];
    //        [mb addObject:seArray1];
    //        [mb addObject:seArray3];
//    [mb addObject:self.secondColumnModel.filter.area_detail];
//    [mb addObject:self.secondColumnModel.filter.area_detail];
//    [mb addObject:self.secondColumnModel.filter.area_detail];
//    [mb addObject:self.secondColumnModel.filter.area_detail];
    
//    YYLog(@"mb - %@",mb);
//    [_dictionary setValue:mb forKey:@"business"];
}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - kTopHeight - SafeAreaBottomHeight);
        _lzTableView = [UITableView lz_initWithFrame:frame
                                               style:UITableViewStylePlain
                                  cellSeparatorStyle:UITableViewCellSeparatorStyleSingleLine
                                      separatorInset:UIEdgeInsetsMake(13, 0, 0, 0)
                        showsVerticalScrollIndicator:false
                                          dataSource:self
                                            delegate:self];
        [_lzTableView registerNib:[UINib nibWithNibName:CellIdentifier bundle:nil]
           forCellReuseIdentifier:CellIdentifier];
        _lzTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _lzTableView.backgroundColor = [UIColor lz_colorWithHex:0xf2f2f2];
    }
    return _lzTableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
