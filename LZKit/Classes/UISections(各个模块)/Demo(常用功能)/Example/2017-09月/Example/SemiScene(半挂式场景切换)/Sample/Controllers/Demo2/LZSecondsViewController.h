//
//  LZSecondsViewController.h
//  LZKit
//
//  Created by 寕小陌 on 2017/08/13.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LZThirdViewController;

@interface LZSecondsViewController : UIViewController {
    LZThirdViewController *semiVC;
}

- (IBAction)buttonDidTouch:(id)sender;


- (IBAction)dismissBtnClick:(id)sender;


@end
