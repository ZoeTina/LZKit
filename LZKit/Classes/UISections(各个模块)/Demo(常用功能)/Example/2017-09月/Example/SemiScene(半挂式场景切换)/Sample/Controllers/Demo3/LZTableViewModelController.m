//
//  LZTableViewModelController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/10/29.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZTableViewModelController.h"

static NSString *CellIdentifier = @"LZTableViewModelController";

@interface LZTableViewModelController ()

@property (nonatomic, strong) LZBaseTableViewCell   *lzBaseCell;

@end

@implementation LZTableViewModelController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.view.frame = CGRectMake(0, 0, kScreenWidth, AUTOLAYOUTSIZE(200));
  }
  return self;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return AUTOLAYOUTSIZE(44);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    self.lzBaseCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                      forIndexPath:indexPath];
    self.lzBaseCell.labelTitle.text = [NSString stringWithFormat:@"Crazy shit %ld", (long)indexPath.row];
    return self.lzBaseCell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
