//
//  UTDropdownAmplifySampleController.m
//  CMKit
//
//  Created by HC on 17/1/10.
//  Copyright © 2017年 UTOUU. All rights reserved.
//

#import "UTDropdownAmplifySampleController.h"
#import "CMDropdownAmplifyView.h"

static NSString *CellIdentifier = @"UTDropdownAmplifySampleController";
static NSString *BaseTableViewCell = @"LZBaseTableViewCell";

@interface UTDropdownAmplifySampleController ()<UITableViewDataSource, UITableViewDelegate>

/** 设置tableview */
@property (nonatomic, strong) UITableView           *lzTableView;
@property (nonatomic, strong) LZBaseTableViewCell   *lzBaseCell;

@end

@implementation UTDropdownAmplifySampleController

#pragma mark - 生命周期
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configUI];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

#pragma mark - 初始化UI
- (void)configUI {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    //拉伸View
    UIImageView *stretchView = [[UIImageView alloc] initWithImage:kGetImage(@"9.jpg")];
    CGFloat stretchViewX = 0;
    CGFloat stretchViewY = 0;
    CGFloat stretchViewW = kScreenWidth;
    CGFloat stretchViewH = 200;
    stretchView.frame = CGRectMake(stretchViewX, stretchViewY, stretchViewW, stretchViewH);
    
    //内容View
    UIImageView *contentView = [[UIImageView alloc] initWithImage:kGetImage(@"6.jpeg")];
    CGFloat contentViewY = (stretchViewH-80)/2;
    CGFloat contentViewX = (stretchViewW-80)/2;
    CGFloat contentViewH = 80;
    CGFloat contentViewW = 80;
    [contentView lz_setCornerRadius:40.0];
    contentView.frame = CGRectMake(contentViewX, contentViewY, contentViewW, contentViewH);
    
    //初始化方法一
    CMDropdownAmplifyView *transparentView = [CMDropdownAmplifyView dropHeaderViewWithFrame:stretchView.frame contentView:contentView stretchView:stretchView];
    /**
     //初始化方法二
     CMDropdownAmplifyView *transparentView = [CMDropdownAmplifyView dropHeaderViewWithFrame:stretchView.frame];
     transparentView.stretchView = stretchView;
     transparentView.contentView = contentView;
     */
    
    self.lzTableView.tableHeaderView = transparentView;
    
    [self.view addSubview:self.lzTableView];

}

/// MARK:- ====================== 懒加载 ======================
-(UITableView *)lzTableView{
    if (!_lzTableView) {
        CGRect frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - SafeAreaBottomHeight);
        _lzTableView = [UITableView lz_initWithFrame:frame
                                               style:UITableViewStylePlain
                                  cellSeparatorStyle:UITableViewCellSeparatorStyleSingleLine
                                      separatorInset:UIEdgeInsetsMake(13, 0, 0, 0)
                        showsVerticalScrollIndicator:false
                                          dataSource:self
                                            delegate:self];
        [_lzTableView registerNib:[UINib nibWithNibName:BaseTableViewCell bundle:nil]
           forCellReuseIdentifier:CellIdentifier];
        _lzTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _lzTableView.backgroundColor = [UIColor lz_colorWithHex:0xf2f2f2];
    }
    return _lzTableView;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lzBaseCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                      forIndexPath:indexPath];
    self.lzBaseCell.imageArrow.hidden = YES;
    self.lzBaseCell.labelTitle.text = [NSString stringWithFormat:@"测试数据 -- %ld",(long)indexPath.row];
    return self.lzBaseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
