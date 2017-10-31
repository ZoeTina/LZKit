//
//  LZMessageViewController.m
//  LZKit
//
//  Created by Ensem on 2017/10/31.
//  Copyright © 2017年 寕小陌. All rights reserved.
//

#import "LZMessageViewController.h"
/** 键盘 */
#import "ChatKeyBoardMacroDefine.h"
#import "ChatKeyBoard.h"

@interface LZMessageViewController ()<ChatKeyBoardDelegate>
///遮盖
@property(nonatomic, strong)UIButton* coverBtn;
@property(nonatomic, strong)ChatKeyBoard *chatKeyBoard;
@end

@implementation LZMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] init];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitleColor:kColorWithRGB(211, 0, 0) forState:UIControlStateNormal];
    [button setTitle:@"聊天" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(openKeyboard:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void) openKeyboard:(UIButton *)sender{
    [self.chatKeyBoard keyboardUpforComment];
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    [self closeDismissKeyboard];
}

-(ChatKeyBoard *)chatKeyBoard{
    if (_chatKeyBoard==nil) {
        _chatKeyBoard =[ChatKeyBoard keyBoardWithNavgationBarTranslucent:NO];
        _chatKeyBoard.delegate = self;
        _chatKeyBoard.backgroundColor = [UIColor whiteColor];
        _chatKeyBoard.keyBoardStyle = KeyBoardStyleComment;
        _chatKeyBoard.allowVoice = NO;
        _chatKeyBoard.allowMore = NO;
        _chatKeyBoard.allowFace = NO;
        _chatKeyBoard.allowSwitchBar = NO;
        _chatKeyBoard.placeHolder = @"快来和小伙伴一起畅聊吧1~";
        [self.view addSubview:_chatKeyBoard];
        [self.view bringSubviewToFront:_chatKeyBoard];
    }
    return _chatKeyBoard;
}

// 点击View 关闭键盘
- (void)closeDismissKeyboard {
    
    // endComment
//    self.bgView.hidden = YES;
    [self.chatKeyBoard keyboardDownForComment];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
