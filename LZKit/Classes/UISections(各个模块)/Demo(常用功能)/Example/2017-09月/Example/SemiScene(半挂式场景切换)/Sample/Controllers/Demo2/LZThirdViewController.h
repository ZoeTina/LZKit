//
//  LZThirdViewController.h
//  LZKit
//
//  Created by 寕小陌 on 2017/08/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LZThirdViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UIButton *dismissButton;
@property (weak, nonatomic) IBOutlet UIButton *resizeButton;

- (IBAction)dismissButtonDidTouch:(id)sender;
- (IBAction)resizeSemiModalView:(id)sender;

@end
