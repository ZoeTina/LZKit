//
//  LZ201710ViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/28.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZ201710ViewController.h"
#import "LZ201710Model.h"

static NSString *CellIdentifier = @"LZ201710ViewController";
static NSString *BaseTableViewCell = @"LZBaseTableViewCell";

@interface LZ201710ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataModelArray;

/** 设置tableview */
@property (nonatomic, strong) UITableView           *lzTableView;
@property (nonatomic, strong) LZBaseTableViewCell   *lzBaseCell;
@property (nonatomic, strong) LZ201710Model         *lzModel;
@end

@implementation LZ201710ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.lzTableView];
    [LZUtils lz_setExtraCellLineHidden:self.lzTableView];
    
    _lzModel = [[LZ201710Model alloc] init];
    _lzModel = [LZ201710Model mj_objectWithKeyValues:_lzModel.getModelData];
    [self.dataModelArray addObjectsFromArray:_lzModel.data];
    
    [self.lzTableView reloadData];
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lzBaseCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                      forIndexPath:indexPath];
    listData *list = self.dataModelArray[indexPath.row];
    self.lzBaseCell.labelTitle.text = list.title;
    return self.lzBaseCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    listData *list = self.dataModelArray[indexPath.row];
    Class class = NSClassFromString(list.className);
    if (class) {
        UIViewController *ctrl = class.new;
        ctrl.title = list.className;
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

- (NSMutableArray *) dataModelArray{
    
    if (_dataModelArray == nil) {
        _dataModelArray = [[NSMutableArray alloc] init];
    }
    return _dataModelArray;
}
@end
