//
//  LZExampleViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZExampleViewController.h"
#import "LZBaseTableViewCell.h"

static NSString *CellIdentifier = @"LZExampleViewController";
static NSString *BaseTableViewCell = @"LZBaseTableViewCell";

@interface LZExampleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *titles;
@property (nonatomic, strong) NSMutableArray *classNames;

/** 设置tableview */
@property (nonatomic, strong) UITableView           *lzTableView;
@property (nonatomic, strong) LZBaseTableViewCell   *lzBaseCell;
@end

@implementation LZExampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.lzTableView];
    [LZUtils lz_setExtraCellLineHidden:self.lzTableView];
    int64_t delayInSeconds = 0.1;      // 延迟的时间
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        self.titles = @[].mutableCopy;
        self.classNames = @[].mutableCopy;
        [self addCell:@"2017-09月" class:@"LZ201709ViewController"];
        [self addCell:@"2017-10月" class:@"LZ201710ViewController"];
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
    
    self.lzBaseCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                  forIndexPath:indexPath];
    self.lzBaseCell.labelTitle.text = _titles[indexPath.row];
    return self.lzBaseCell;
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
        [_lzTableView registerNib:[UINib nibWithNibName:BaseTableViewCell bundle:nil]
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
