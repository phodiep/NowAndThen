//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Gru on 02/25/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineViewController.h"

@interface SkylineViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *kerryPark;

@property (strong, nonatomic) UIButton *twoUnionSquare;
@property (strong, nonatomic) UIButton *spaceNeedle;
@property (strong, nonatomic) UIButton *columbiaTower;
@property (strong, nonatomic) UIButton *mtRainier;

@property (strong, nonatomic) UIView *waMutualBuilding;
@property (strong, nonatomic) UIView *portOfSeattle;
@property (strong, nonatomic) UIView *keyArena;

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
    
    [self setBuildingBorders];
    
    //set scrollView -------------
    self.kerryPark.image = [UIImage imageNamed:@"KerryPark1.jpeg"];
    
    

    
    
    [self.kerryPark setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.scrollView addSubview:self.kerryPark];
    
    NSDictionary *views = @{@"kerryPark":self.kerryPark};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[kerryPark]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[kerryPark]|" options:0 metrics:nil views:views]];
    
    [self.scrollView addSubview:self.twoUnionSquare];
    [self.scrollView addSubview:self.spaceNeedle];
    [self.scrollView addSubview:self.columbiaTower];
    [self.scrollView addSubview:self.mtRainier];
    
    self.view = rootView;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    [self.scrollView setContentOffset:CGPointMake(300, 0) animated:true];
    
}


#pragma mark - Button Actions
-(void)pressedTwoUnionSquare {
    NSLog(@"Two Union Square");
    if (self.twoUnionSquare.backgroundColor == nil || self.twoUnionSquare.backgroundColor == [UIColor clearColor]) {
        self.twoUnionSquare.backgroundColor = [UIColor redColor];
    } else {
        self.twoUnionSquare.backgroundColor = [UIColor clearColor];
    }
}

-(void)pressedSpaceNeedle {
    NSLog(@"Space Needle");
    if (self.spaceNeedle.backgroundColor == nil || self.spaceNeedle.backgroundColor == [UIColor clearColor]) {
        self.spaceNeedle.backgroundColor = [UIColor redColor];
    } else {
        self.spaceNeedle.backgroundColor = [UIColor clearColor];
    }
}

-(void)pressedColumbiaTower {
    NSLog(@"Columbia Tower");
    if (self.columbiaTower.backgroundColor == nil || self.columbiaTower.backgroundColor == [UIColor clearColor]) {
        self.columbiaTower.backgroundColor = [UIColor blueColor];
    } else {
        self.columbiaTower.backgroundColor = [UIColor clearColor];
    }
}

-(void)pressedMtRainier {
    NSLog(@"Mt Rainier");
    if (self.mtRainier.backgroundColor == nil || self.mtRainier.backgroundColor == [UIColor clearColor]) {
        self.mtRainier.backgroundColor = [UIColor redColor];
    } else {
        self.mtRainier.backgroundColor = [UIColor clearColor];
    }

}


#pragma mark - building borders
-(void)setBuildingBorders {
    self.twoUnionSquare = [[UIButton alloc] initWithFrame:CGRectMake(228, 200, 35, 80)];
    self.spaceNeedle = [[UIButton alloc] initWithFrame:CGRectMake(390, 160, 40, 170)];
    self.columbiaTower = [[UIButton alloc] initWithFrame:CGRectMake(415, 190, 20, 100)];
    self.mtRainier = [[UIButton alloc] initWithFrame:CGRectMake(650, 220, 120, 50)];
    
//    self.twoUnionSquare.backgroundColor = [UIColor redColor];
//    self.spaceNeedle.backgroundColor = [UIColor redColor];
//    self.columbiaTower.backgroundColor = [UIColor blueColor];
//    self.mtRainier.backgroundColor = [UIColor redColor];

    
    self.twoUnionSquare.alpha = 0.3;
    self.spaceNeedle.alpha = 0.3;
    self.columbiaTower.alpha = 0.3;
    self.mtRainier.alpha = 0.3;
    
    [self.spaceNeedle addTarget:self action:@selector(pressedSpaceNeedle) forControlEvents:UIControlEventTouchUpInside];
    [self.twoUnionSquare addTarget:self action:@selector(pressedTwoUnionSquare) forControlEvents:UIControlEventTouchUpInside];
    [self.columbiaTower addTarget:self action:@selector(pressedColumbiaTower) forControlEvents:UIControlEventTouchUpInside];
    [self.mtRainier addTarget:self action:@selector(pressedMtRainier) forControlEvents:UIControlEventTouchUpInside];
    
    
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


@end
