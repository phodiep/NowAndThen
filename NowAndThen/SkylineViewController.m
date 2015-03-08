//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Gru on 02/25/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineViewController.h"
#import "Building.h"
#import "NetworkController.h"

@interface SkylineViewController () <UIScrollViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic) BOOL firstScroll;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *kerryPark;
@property (strong, nonatomic) UIButton *goToSelectedBuilding;
@property (strong, nonatomic) UILabel *selectedBuildingName;

@property (strong, nonatomic) NSArray *buildings;
@property (strong, nonatomic) Building *selectedBuilding;

@property (strong, nonatomic) UIButton *twoUnionSquare;
@property (strong, nonatomic) UIButton *spaceNeedle;
@property (strong, nonatomic) UIButton *columbiaTower;
@property (strong, nonatomic) UIButton *mtRainier;

@property (strong, nonatomic) UIButton *waMutualBuilding;
@property (strong, nonatomic) UIButton *portOfSeattle;
@property (strong, nonatomic) UIButton *keyArena;

@end

@implementation SkylineViewController

-(void)loadView {
    
    [[NetworkController sharedService] fetchBuildings:^(NSArray *results) {
        self.buildings = [[NSArray alloc] initWithArray:results];
    }];

    self.firstScroll = false;
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    
    self.goToSelectedBuilding = [[UIButton alloc] init];
    [self.goToSelectedBuilding setImage:[UIImage imageNamed:@"info"] forState:UIControlStateNormal];
    self.goToSelectedBuilding.hidden = true;
    
    [[self.goToSelectedBuilding layer] setBorderWidth:2.0f];
    [[self.goToSelectedBuilding layer] setBorderColor:[UIColor grayColor].CGColor];
    
    [self.goToSelectedBuilding addTarget:self action:@selector(goToBuilding) forControlEvents:UIControlEventTouchUpInside];
    
    self.selectedBuildingName = [[UILabel alloc] init];
    self.selectedBuildingName.text = @" ";
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    self.scrollView.maximumZoomScale = 1.5;
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Seattle Skyline From Kerry Park";
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.goToSelectedBuilding setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.selectedBuildingName setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:false];

    [rootView addSubview:title];
    [rootView addSubview:self.goToSelectedBuilding];
    [rootView addSubview:self.selectedBuildingName];
    [rootView addSubview:self.scrollView];
    
    NSDictionary *rootViews = @{@"scrollView":self.scrollView, @"title":title, @"selectedBuilding":self.selectedBuildingName, @"goTo":self.goToSelectedBuilding};
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[title]-8-|" options:0 metrics:nil views:rootViews]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[goTo(40)]-8-[selectedBuilding]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:rootViews]];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:rootViews]];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-30-[title]-8-[goTo(40)]-[scrollView]-50-|" options:0 metrics:nil views:rootViews]];
    
    [self setBuildingBorders];

    self.kerryPark.image = [UIImage imageNamed:@"KerryPark1.jpeg"];
    self.kerryPark.userInteractionEnabled = true;
    
    [self.kerryPark addSubview:self.twoUnionSquare];
    [self.kerryPark addSubview:self.spaceNeedle];
    [self.kerryPark addSubview:self.columbiaTower];
    [self.kerryPark addSubview:self.mtRainier];
    [self.kerryPark addSubview:self.waMutualBuilding];
    [self.kerryPark addSubview:self.portOfSeattle];
    [self.kerryPark addSubview:self.keyArena];

    
    [self.kerryPark setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.scrollView addSubview:self.kerryPark];
    
    NSDictionary *views = @{@"kerryPark":self.kerryPark};
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[kerryPark]|" options:0 metrics:nil views:views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[kerryPark]|" options:0 metrics:nil views:views]];
    
    self.view = rootView;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    if (self.firstScroll == false) {
        [self.scrollView setContentOffset:CGPointMake(250, 50) animated:true];
        self.firstScroll = true;
    }
}

-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.kerryPark;
}

-(Building *)findBuilding:(NSString *)buildingName {
    for (Building *building in self.buildings) {
        if ([building.name isEqualToString: buildingName]) {
            return building;
        }
    }
    return nil;
}

#pragma mark - Button Actions
-(void)pressedTwoUnionSquare {
    [self unselectAllButtons];
    self.twoUnionSquare.backgroundColor = [UIColor redColor];
    self.selectedBuilding = [self findBuilding:@"Union square"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
    self.goToSelectedBuilding.hidden = false;
}

-(void)pressedSpaceNeedle {
    [self unselectAllButtons];
    self.spaceNeedle.backgroundColor = [UIColor redColor];
    self.selectedBuilding = [self findBuilding:@"Space Needle"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
    self.goToSelectedBuilding.hidden = false;
}

-(void)pressedColumbiaTower {
    [self unselectAllButtons];
    self.columbiaTower.backgroundColor = [UIColor blueColor];
    self.selectedBuilding = [self findBuilding:@"Seattle Municipal Tower"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
    self.goToSelectedBuilding.hidden = false;
}

-(void)pressedMtRainier {
    [self unselectAllButtons];
    self.mtRainier.backgroundColor = [UIColor redColor];
    self.selectedBuilding = nil;
    self.selectedBuildingName.text = @"Mt Rainier";
    self.goToSelectedBuilding.hidden = true;
}

-(void)pressedWaMuBuilding {
    [self unselectAllButtons];
    self.waMutualBuilding.backgroundColor = [UIColor redColor];
    self.selectedBuilding = [self findBuilding:@"Seattle Washington Mutual Tower"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
    self.goToSelectedBuilding.hidden = false;
}

-(void)pressedPortOfSeattle {
    [self unselectAllButtons];
    self.portOfSeattle.backgroundColor = [UIColor redColor];
    self.selectedBuilding = nil;
    self.selectedBuildingName.text = @"Port of Seattle";
    self.goToSelectedBuilding.hidden = true;
}

-(void)pressedKeyArena {
    [self unselectAllButtons];
    self.keyArena.backgroundColor = [UIColor redColor];
    self.selectedBuilding = nil;
    self.selectedBuildingName.text = @"Key Arena";
    self.goToSelectedBuilding.hidden = true;
}

-(void)unselectAllButtons {
    self.twoUnionSquare.backgroundColor = [UIColor clearColor];
    self.spaceNeedle.backgroundColor = [UIColor clearColor];
    self.columbiaTower.backgroundColor = [UIColor clearColor];
    self.mtRainier.backgroundColor = [UIColor clearColor];
    self.waMutualBuilding.backgroundColor = [UIColor clearColor];
    self.portOfSeattle.backgroundColor = [UIColor clearColor];
    self.keyArena.backgroundColor = [UIColor clearColor];
}

-(void)goToBuilding {
    if (self.selectedBuilding != nil) {
        [self transitionToBuildingDetail];
    }
}

#pragma mark - transitionToBuildingDetail
- (void)transitionToBuildingDetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedBuilding"
                                                        object:self
                                                      userInfo:@{@"Building" : self.selectedBuilding}];
    int tabIndex = 0;
    
    UITabBarController *tabBarController = self.tabBarController;
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [[tabBarController.viewControllers objectAtIndex:tabIndex] view];
    
    [UIView transitionFromView:fromView
                        toView:toView
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = tabIndex;
                        }
                    }];
}


#pragma mark - building borders
-(void)setBuildingBorders {
    self.twoUnionSquare = [[UIButton alloc] initWithFrame:CGRectMake(228, 160, 35, 80)];
    self.spaceNeedle = [[UIButton alloc] initWithFrame:CGRectMake(390, 120, 40, 170)];
    self.columbiaTower = [[UIButton alloc] initWithFrame:CGRectMake(415, 150, 20, 100)];
    self.mtRainier = [[UIButton alloc] initWithFrame:CGRectMake(650, 180, 120, 50)];
    self.waMutualBuilding = [[UIButton alloc] initWithFrame:CGRectMake(475, 170, 25, 90)];
    self.portOfSeattle = [[UIButton alloc] initWithFrame:CGRectMake(1080, 250, 150, 50)];
    self.keyArena = [[UIButton alloc] initWithFrame:CGRectMake(630, 310, 150, 50)];
    
//    self.twoUnionSquare.backgroundColor = [UIColor redColor];
//    self.spaceNeedle.backgroundColor = [UIColor redColor];
//    self.columbiaTower.backgroundColor = [UIColor blueColor];
//    self.mtRainier.backgroundColor = [UIColor redColor];
//    self.waMutualBuilding.backgroundColor = [UIColor redColor];
//    self.portOfSeattle.backgroundColor = [UIColor redColor];
//    self.keyArena.backgroundColor = [UIColor redColor];
    
    self.twoUnionSquare.alpha = 0.3;
    self.spaceNeedle.alpha = 0.3;
    self.columbiaTower.alpha = 0.3;
    self.mtRainier.alpha = 0.3;
    self.waMutualBuilding.alpha = 0.3;
    self.portOfSeattle.alpha = 0.3;
    self.keyArena.alpha = 0.3;
    
    [self.spaceNeedle addTarget:self action:@selector(pressedSpaceNeedle) forControlEvents:UIControlEventTouchUpInside];
    [self.twoUnionSquare addTarget:self action:@selector(pressedTwoUnionSquare) forControlEvents:UIControlEventTouchUpInside];
    [self.columbiaTower addTarget:self action:@selector(pressedColumbiaTower) forControlEvents:UIControlEventTouchUpInside];
    [self.mtRainier addTarget:self action:@selector(pressedMtRainier) forControlEvents:UIControlEventTouchUpInside];
    [self.waMutualBuilding addTarget:self action:@selector(pressedWaMuBuilding) forControlEvents:UIControlEventTouchUpInside];
    [self.portOfSeattle addTarget:self action:@selector(pressedPortOfSeattle) forControlEvents:UIControlEventTouchUpInside];
    [self.keyArena addTarget:self action:@selector(pressedKeyArena) forControlEvents:UIControlEventTouchUpInside];
    
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
