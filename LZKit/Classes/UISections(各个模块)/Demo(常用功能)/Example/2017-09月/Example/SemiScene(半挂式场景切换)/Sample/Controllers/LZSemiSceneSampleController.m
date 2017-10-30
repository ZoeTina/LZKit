//
//  LZSemiSceneSampleController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/01/19.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZSemiSceneSampleController.h"
#import "LZFirstViewController.h"
#import "LZSecondViewController.h"
#import "LZTableViewDemoController.h"


@interface LZSemiSceneSampleController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSArray *toolArray;

@end

@implementation LZSemiSceneSampleController


#pragma mark - 生命周期方法
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    
    [self initUI];
    
}

#pragma mark - 初始化数据
- (void)initData{
    self.toolArray = @[@{@"name":@"Demo1",@"classType":[LZFirstViewController class]},
                       @{@"name":@"Demo2",@"classType":[LZSecondViewController class]},
                       @{@"name":@"Demo3",@"classType":[LZTableViewDemoController class]}];
    
}


#pragma mark - 初始化UI
//创建UI
- (void)initUI{
    
    //1.创建TableView
    UITableView *tableView = [UITableView lz_initWithFrame:self.view.bounds
                                                     style:UITableViewStylePlain
                                        cellSeparatorStyle:UITableViewCellSeparatorStyleSingleLine
                                            separatorInset:UIEdgeInsetsMake(0, 0, 0, 0)
                              showsVerticalScrollIndicator:false
                                                dataSource:self
                                                  delegate:self];
    
    [self.view addSubview:tableView];
    
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.toolArray.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *ID = @"LZSemiSceneSampleController";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    NSDictionary *dict = self.toolArray[indexPath.row];
    cell.textLabel.text = dict[@"name"];
    
    return cell;
    
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictionary = self.toolArray[indexPath.row];
    if (dictionary) {
        
        if ([dictionary[@"classType"] isEqual:[LZSecondViewController class]]) {
            UIViewController *Vc = [[dictionary[@"classType"] alloc] init];
            Vc.hidesBottomBarWhenPushed = YES;
            [self presentViewController:Vc animated:YES completion:nil];
            
        }else if([dictionary[@"classType"] isEqual:@""]){
            [LZUtilsToast showText:@"功能暂未完善"];
            
        }else{
            UIViewController *Vc = [[dictionary[@"classType"] alloc] init];
            Vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:Vc animated:YES];
        }
        
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}


@end
