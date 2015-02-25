//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Gru on 02/25/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "BuildingViewController.h"
#import "MenuViewController.h"
#import "Building.h"
#import "ImageCell.h"
#import "SkylineViewController.h"

@interface SkylineViewController ()

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *skylineTitle;

-(void)building164;

@end

@implementation SkylineViewController

- (IBAction)building164 {
    NSLog(@"building164");
}
- (void)loadView {
    self.skylineTitle.numberOfLines = 0;
    self.skylineTitle.lineBreakMode = NSLineBreakByWordWrapping;

    [self applyTextFormat:self.skylineTitle     setText:@"Kerry Park"];

    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
    self.scrollView.bounces = true;
    self.scrollView.backgroundColor = [UIColor grayColor];

    [self setupAutolayoutForRootView];
    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"SkylineViewController::viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SkylineViewController::didReceiveMemoryWarning");
}

#pragma mark - Autolayout methods
-(void)prepObjectForAutoLayout:(id)object addToSubView:(UIView*)view addToDictionary:(NSString*)reference {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
}


-(void)prepareScrollViewForAutolayout {
    [self prepObjectForAutoLayout: self.skylineTitle        addToSubView:self.scrollView  addToDictionary:@"skylineTitle"];
}

-(void)applyTextFormat:(UILabel*)label setText:(NSString*)text {
    label.text = text;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
}

-(void)applyAutolayoutConstraintsToScrollView {
    NSDictionary *metrics = @{@"width": @(CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - 16)};
    [self.scrollView removeConstraints:[self.scrollView constraints]];

    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[addressLabel]-[address]-[cityStateZip]-25-[buildLabel]-[buildDate]-[completionLabel]-[completionDate]-25-[crossNSLabel]-[crossNS]-[crossEWLabel]-[crossEW]-25-[infoLabel]-[skylineTitle]-25-[imageFlow(300)]-50-|" options:0 metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[skylineTitle(width)]-|" options:0 metrics:metrics views:self.views]];
}

-(void)setupAutolayoutForRootView {
    [self prepObjectForAutoLayout: self.scrollView     addToSubView:self.rootView  addToDictionary:@"scrollView"];
//    [self prepObjectForAutoLayout: self.buildingLabel  addToSubView:self.rootView  addToDictionary:@"buildingLabel"];
//    [self prepObjectForAutoLayout: self.menuButton     addToSubView:self.rootView  addToDictionary:@"menuButton"];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"                              options:0 metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[menuButton]-16-[buildingLabel]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[menuButton]-8-[scrollView]|"           options:0 metrics:nil views:self.views]];
}

-(UIView *)rootView {
    if (_rootView == nil) {
        _rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    }
    return _rootView;
}

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
}

-(UILabel *)skylineTitle {
    if (_skylineTitle == nil) {
        _skylineTitle = [[UILabel alloc] init];
    }
    return _skylineTitle;
}
@end
