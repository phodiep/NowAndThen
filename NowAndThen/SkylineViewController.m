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

@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIImageView *kerryPark;
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

    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    
    self.selectedBuildingName = [[UILabel alloc] init];
    self.selectedBuildingName.text = @" ";
    
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] init];
    title.text = @"Seattle Skyline From Kerry Park";
    title.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18.0f];
    
    [title setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.selectedBuildingName setTranslatesAutoresizingMaskIntoConstraints:false];
    [self.scrollView setTranslatesAutoresizingMaskIntoConstraints:false];

    [rootView addSubview:title];
    [rootView addSubview:self.selectedBuildingName];
    [rootView addSubview:self.scrollView];
    
    NSDictionary *rootViews = @{@"scrollView":self.scrollView, @"title":title, @"selectedBuilding":self.selectedBuildingName};
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[title]-8-|" options:0 metrics:nil views:rootViews]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[selectedBuilding]-8-|" options:0 metrics:nil views:rootViews]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:rootViews]];

    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-40-[title]-8-[selectedBuilding]-8-[scrollView]|" options:0 metrics:nil views:rootViews]];
    
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
    [self.scrollView addSubview:self.waMutualBuilding];
    [self.scrollView addSubview:self.portOfSeattle];
    [self.scrollView addSubview:self.keyArena];
    
    self.view = rootView;
}


-(void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.delegate = self;
    
    [self.scrollView setContentOffset:CGPointMake(300, 0) animated:true];
    
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
}

-(void)pressedSpaceNeedle {
    [self unselectAllButtons];

    self.spaceNeedle.backgroundColor = [UIColor redColor];
    self.selectedBuilding = [self findBuilding:@"Space Needle"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
}

-(void)pressedColumbiaTower {
    [self unselectAllButtons];
    self.columbiaTower.backgroundColor = [UIColor blueColor];
    self.selectedBuilding = [self findBuilding:@"Seattle Municipal Tower"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
}

-(void)pressedMtRainier {
    [self unselectAllButtons];
    self.mtRainier.backgroundColor = [UIColor redColor];
//    self.selectedBuilding = [self findBuilding:@"Union square"];
    self.selectedBuildingName.text = @"Mt Rainier";
}

-(void)pressedWaMuBuilding {
    [self unselectAllButtons];
    self.waMutualBuilding.backgroundColor = [UIColor redColor];
    self.selectedBuilding = [self findBuilding:@"Seattle Washington Mutual Tower"];
    self.selectedBuildingName.text = self.selectedBuilding.name;
}

-(void)pressedPortOfSeattle {
    [self unselectAllButtons];
    self.portOfSeattle.backgroundColor = [UIColor redColor];
//    self.selectedBuilding = [self findBuilding:@"Union square"];
    self.selectedBuildingName.text = @"Port of Seattle";
}

-(void)pressedKeyArena {
    [self unselectAllButtons];
    self.keyArena.backgroundColor = [UIColor redColor];
//    self.selectedBuilding = [self findBuilding:@"Union square"];
    self.selectedBuildingName.text = @"Key Arena";
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

#pragma mark - building borders
-(void)setBuildingBorders {
    self.twoUnionSquare = [[UIButton alloc] initWithFrame:CGRectMake(228, 200, 35, 80)];
    self.spaceNeedle = [[UIButton alloc] initWithFrame:CGRectMake(390, 160, 40, 170)];
    self.columbiaTower = [[UIButton alloc] initWithFrame:CGRectMake(415, 190, 20, 100)];
    self.mtRainier = [[UIButton alloc] initWithFrame:CGRectMake(650, 220, 120, 50)];
    self.waMutualBuilding = [[UIButton alloc] initWithFrame:CGRectMake(475, 210, 25, 90)];
    self.portOfSeattle = [[UIButton alloc] initWithFrame:CGRectMake(1080, 290, 150, 50)];
    self.keyArena = [[UIButton alloc] initWithFrame:CGRectMake(630, 350, 150, 50)];
    
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
