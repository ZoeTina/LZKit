//
//  LZSecondsViewController.m
//  LZKit
//
//  Created by 寕小陌 on 2017/08/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZSecondsViewController.h"
#import "LZThirdViewController.h"
#import "UIViewController+LZSemiModal.h"

@interface LZSecondsViewController ()


@end

@implementation LZSecondsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = @"Second";
      self.tabBarItem.image = [UIImage imageNamed:@"second"];

      // Take note that you need to take ownership of the ViewController that is being presented
      semiVC = [[LZThirdViewController alloc] initWithNibName:@"LZThirdViewController" bundle:nil];

      // You can optionally listen to notifications
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModelPresented:)
                                                   name:kSemiModelDidShowNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModelDismissed:)
                                                   name:kSemiModelDidHideNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModelResized:)
                                                   name:kSemiModelWasResizedNotification
                                                 object:nil];
    }
    return self;
}

#pragma mark - Demo

- (IBAction)buttonDidTouch:(id)sender {

  // You can also present a UIViewController with complex views in it
  // and optionally containing an explicit dismiss button for semi modal
  [self lz_presentSemiViewController:semiVC withOptions:@{
		 LZSemiModelOptionKeys.pushParentBack    : @(YES),
		 LZSemiModelOptionKeys.animationDuration : @(2.0),
		 LZSemiModelOptionKeys.shadowOpacity     : @(0.3),
	 }];

}

- (IBAction)dismissBtnClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Optional notifications

- (void) semiModelResized:(NSNotification *) notification {
  if(notification.object == self){
    YYLog(@"The view controller presented was been resized");
  }
}

- (void)semiModelPresented:(NSNotification *) notification {
  if (notification.object == self) {
    YYLog(@"This view controller just shown a view with semi modal annimation");
  }
}

- (void)semiModelDismissed:(NSNotification *) notification {
  if (notification.object == self) {
    YYLog(@"A view controller was dismissed with semi modal annimation");
  }
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
