//
//  LZThirdViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/08/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZThirdViewController.h"
#import "UIViewController+LZSemiModal.h"
#import <QuartzCore/QuartzCore.h>

@interface LZThirdViewController ()

@end

@implementation LZThirdViewController
//@synthesize helpLabel;
//@synthesize dismissButton;
//@synthesize resizeButton;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  self.dismissButton.layer.cornerRadius  = 10.0f;
  self.dismissButton.layer.masksToBounds = YES;
  self.resizeButton.layer.cornerRadius   = 10.0f;
  self.resizeButton.layer.masksToBounds  = YES;
}

//- (void)viewDidUnload {
//  [self setHelpLabel:nil];
//  [self setDismissButton:nil];
//  [self setResizeButton:nil];
//  [super viewDidUnload];
//}

- (IBAction)dismissButtonDidTouch:(id)sender {

  // Here's how to call dismiss button on the parent ViewController
  // be careful with view hierarchy
  UIViewController * parent = [self.view lz_containingViewController];
  if ([parent respondsToSelector:@selector(lz_dismissSemiModalView)]) {
    [parent lz_dismissSemiModalView];
  }

}

- (IBAction)resizeSemiModalView:(id)sender {
  UIViewController * parent = [self.view lz_containingViewController];
  if ([parent respondsToSelector:@selector(lz_resizeSemiView:)]) {
    [parent lz_resizeSemiView:CGSizeMake(kScreenWidth, arc4random() % 280 + 180)];
  }
}

@end
