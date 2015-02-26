//
//  WebViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/25/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "WebViewController.h"
#import <WebKit/WebKit.h>


@interface WebViewController ()


@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIButton *backButton;

@end

@implementation WebViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor lightGrayColor];
    
    [self.backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.backButton setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.webView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [rootView addSubview:self.backButton];
    [rootView addSubview:self.webView];

    NSDictionary *views = @{@"back":self.backButton,
                            @"web":self.webView};
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[back]-8-[web]|" options:0 metrics:nil views:views]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[back]-(>=8)-|" options:0 metrics:nil views:views]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[web]|" options:0 metrics:nil views:views]];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [NSURL URLWithString:self.link];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

#pragma mark - Button actions
-(void)backButtonPressed {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - Lazy loading Getters
-(UIWebView *)webView {
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
    }
    return _webView;
}

-(UIButton *)backButton {
    if (_backButton == nil) {
        _backButton = [[UIButton alloc] init];
    }
    return _backButton;
}


@end
