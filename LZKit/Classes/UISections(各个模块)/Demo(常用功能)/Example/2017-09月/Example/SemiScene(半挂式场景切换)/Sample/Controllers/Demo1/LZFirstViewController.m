//
//  LZFirstViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/08/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZFirstViewController.h"
#import "UIViewController+LZSemiModal.h"

@interface LZFirstViewController ()

- (IBAction)buttonDidTouch:(id)sender;

@end

@implementation LZFirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = NSLocalizedString(@"First", @"First");
      self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
  if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
      return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
  } else {
      return YES;
  }
}

- (IBAction)buttonDidTouch:(id)sender {
  // 你可以展示一个简单的UIImageView或任何其他UIView这样的,
  // without needing to take care of dismiss action
  UIImageView * imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp.jpg"]];
  UIImageView * bgimgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background_01"]];
  [self lz_presentSemiView:imagev withOptions:@{ LZSemiModelOptionKeys.backgroundView:bgimgv }];
}

@end
