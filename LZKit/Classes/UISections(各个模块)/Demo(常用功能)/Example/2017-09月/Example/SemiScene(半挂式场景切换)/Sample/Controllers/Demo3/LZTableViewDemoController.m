//
//  LZTableViewDemoController.h
//  LZKit
//
//  Created by 寕小陌 on 2017/10/29.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZTableViewDemoController.h"
#import "UIViewController+LZSemiModal.h"
#import "LZTableViewModelController.h"

static NSString *CellIdentifier = @"LZTableViewDemoController";

@interface LZTableViewDemoController ()

@property (nonatomic, strong) LZBaseTableViewCell   *lzBaseCell;

@end

@implementation LZTableViewDemoController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = @"Third";
    modalVC = [[LZTableViewModelController alloc] initWithStyle:UITableViewStylePlain];
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
    
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  // You have to retain the ownership of ViewController that you are presenting
  [self lz_presentSemiViewController:modalVC withOptions:@{
		 LZSemiModelOptionKeys.pushParentBack : @(NO),
		 LZSemiModelOptionKeys.parentAlpha : @(0.8)
	 }];
  
  // The following code won't work
//  LZTableViewDemoController * vc = [[LZTableViewDemoController alloc] initWithStyle:UITableViewStylePlain];
//  [self presentSemiViewController:vc];
}

@end
