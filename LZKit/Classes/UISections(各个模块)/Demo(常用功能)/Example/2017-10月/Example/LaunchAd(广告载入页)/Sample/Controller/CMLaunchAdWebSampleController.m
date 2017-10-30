//
//  CMLaunchAdWebSampleController.m
//  CMKit
//
//  Created by HC on 16/12/26.
//  Copyright © 2016年 UTOUU. All rights reserved.
//

#import "CMLaunchAdWebSampleController.h"

@interface CMLaunchAdWebSampleController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation CMLaunchAdWebSampleController

#pragma mark - 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initUI];
 
}

#pragma mark - 初始化UI
- (void)initUI {
    //1.
    self.title = @"详情";
    
    //2.
    _webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:self.URLString]];
    _webView.delegate = self;
    [_webView loadRequest:request];
    
    [self.view addSubview:_webView];
}


#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    [LZUtilsToast showMessage:@"加载中" toView:self.webView];
    [LZUtilsToast showLoadingText:@"加载中"];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [LZUtilsToast hide];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

//    [MBProgressHUD hideHUDForView:self.webView];
    [LZUtilsToast hide];
}



@end
