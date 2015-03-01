//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Gru on 02/25/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineViewController.h"

@interface SkylineViewController () <UIScrollViewDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *kerryPark;

@property (strong, nonatomic) UIButton *spaceNeedleButton;

@end

@implementation SkylineViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Seattle Skyline From Kerry Park";
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:false];

    [rootView addSubview:title];
    [rootView addSubview:self.scrollView];
    
    NSDictionary *rootViews = @{@"scrollView":self.scrollView, @"title":title};
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[title]-8-|" options:0 metrics:nil views:rootViews]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:rootViews]];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[title]-8-[scrollView]|" options:0 metrics:nil views:rootViews]];
    
    
    
    //set scrollView -------------
    self.kerryPark.image = [UIImage imageNamed:@"KerryPark1.jpeg"];
    
    self.spaceNeedleButton.backgroundColor = [UIColor redColor];
    
    
    [self.kerryPark setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.spaceNeedleButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.scrollView addSubview:self.kerryPark];
//    [self.scrollView addSubview:self.spaceNeedleButton];
    
    NSDictionary *views = @{@"kerryPark":self.kerryPark, @"spaceNeedle":self.spaceNeedleButton};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[kerryPark]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[kerryPark]|" options:0 metrics:nil views:views]];
    
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-390-[spaceNeedle(40)]" options:0 metrics:nil views:views]];
//    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-180-[spaceNeedle(200)]" options:0 metrics:nil views:views]];
    
    
    
    self.view = rootView;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    [self.scrollView setContentOffset:CGPointMake(300, 0) animated:true];
}


#pragma mark - lazy loading Getters
-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

-(UIImageView *)kerryPark {
    if (_kerryPark == nil) {
        _kerryPark = [[UIImageView alloc] init];
    }
    return _kerryPark;
}

-(UIButton *)spaceNeedleButton {
    if (_spaceNeedleButton == nil) {
        _spaceNeedleButton = [[UIButton alloc] init];
    }
    return _spaceNeedleButton;
}

@end
