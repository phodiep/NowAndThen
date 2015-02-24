//
//  BuildingViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuildingViewController.h"
#import "MenuViewController.h"
#import "Building.h"

@interface BuildingViewController ()

@property (strong, nonatomic) NSMutableArray *buildings;      // Array of 'Building' NSMutableDictionary(s)

//@property (strong, nonatomic) Building *building;
//@property (strong, nonatomic) Building *currentBuilding;

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic) CGFloat *screenWidth;
@property (nonatomic) CGFloat *screenHeight;

@property (strong, nonatomic) UIImageView *oldImage;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UILabel *buildingLabel;
@property (strong, nonatomic) UILabel *buildingInfo;

@property (strong, nonatomic) UIButton *menuButton;
//@property (strong, nonatomic) MenuViewController *menuVC;

@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;

@end

@implementation BuildingViewController

- (void)loadView {

    self.building = [[Building alloc]init];

    [self setScrollViewFrameForFullScreen];
    self.scrollView.bounces = true;
    
    [self setSampleView];
    
    self.buildingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    self.buildingInfo.font  = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
    
    self.buildingInfo.numberOfLines = 0;
    self.buildingInfo.lineBreakMode = NSLineBreakByWordWrapping;

    UIImage *menuImage = [UIImage imageNamed:@"menu"];
    [self.menuButton setImage:menuImage forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupAutolayoutForScrollView];
    [self setupAutolayoutConstraintsForScrollView];

    [self setupAutolayoutForRootView];
    [self setupAutolayoutConstraintsForRootView];

    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.buildingName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //reset autolayout constraints when screen is rotated
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self setupAutolayoutConstraintsForScrollView];
    } completion:nil];
}

-(void)setupAutolayoutForRootView {
    [self setupObjectForAutoLayout: self.scrollView  addToSubView:self.rootView  addToDictionary:@"scrollView"];
    [self setupObjectForAutoLayout: self.buildingLabel  addToSubView:self.rootView  addToDictionary:@"buildingLabel"];
    [self setupObjectForAutoLayout: self.menuButton  addToSubView:self.rootView  addToDictionary:@"menuButton"];

}

-(void)setupAutolayoutConstraintsForRootView {
    [self.rootView removeConstraints:[self.rootView constraints]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[menuButton]-16-[buildingLabel]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[menuButton]-8-[scrollView]|" options:0 metrics:nil views:self.views]];

    
}

-(void)setupAutolayoutForScrollView {
    [self setupObjectForAutoLayout: self.oldImage       addToSubView:self.scrollView  addToDictionary:@"oldImage"];
    [self setupObjectForAutoLayout: self.currentImage   addToSubView:self.scrollView  addToDictionary:@"currentImage"];
    [self setupObjectForAutoLayout: self.buildingInfo   addToSubView:self.scrollView  addToDictionary:@"buildingInfo"];
}

-(void)setupAutolayoutConstraintsForScrollView {
    [self.scrollView removeConstraints:[self.scrollView constraints]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[buildingInfo]-8-[oldImage]-[currentImage]-|" options:0 metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[oldImage]-8-|" options:0 metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[currentImage]-8-|" options:0 metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[buildingInfo(width)]-|" options:0
                                                                            metrics: @{@"width": @(CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - 16) }
                                                                              views:self.views]];
}

-(void)setScrollViewFrameForFullScreen {
    self.scrollView.frame = CGRectMake(0, 0,
                                       CGRectGetWidth([[UIScreen mainScreen] applicationFrame]),
                                       CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
}

-(void)setSampleView {
    self.oldImage.image = [UIImage imageNamed:@"smithTowerOld"];
    self.oldImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.currentImage.image = [UIImage imageNamed:@"smithTowerNew"];
    self.currentImage.contentMode = UIViewContentModeScaleAspectFit;


    
    self.buildingLabel.text = @"Smith Tower";  //self.building.buildingName;
//    self.buildingLabel.text = _building[@"BuildingName"];
//    NSLog(@"%@", self.buildingLabel.text );
//    NSLog(@"%@", self.building.buildingName );

    
    self.buildingInfo.text = @"Smith Tower is a skyscraper in Pioneer Square in Seattle, Washington. Completed in 1914, the 38-story, 149 m (489 ft) tower is the oldest skyscraper in the city and was the tallest office building west of the Mississippi River until the Kansas City Power & Light Building was built in 1931. It remained the tallest building on the West Coast until the Space Needle overtook it in 1962. \n\nSmith Tower is named after its builder, firearm and typewriter magnate Lyman Cornelius Smith, and is a designated Seattle landmark.";
}

-(void)setupBuildingInformation:(id)object getBuildingInfo:(Building*)building {

}

-(void)setupObjectForAutoLayout:(id)object addToSubView:(UIView*)view addToDictionary:(NSString*)reference {

    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
    
}

#pragma mark - Button Actions
-(void)menuButtonPressed {

    __weak BuildingViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x + 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.view addGestureRecognizer:weakSelf.tapToClose];
    }];
}

-(void)closePanel {
    
    __weak BuildingViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x - 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.view removeGestureRecognizer:weakSelf.tapToClose];
    }];
}

#pragma mark - Lazy Loading Getters
-(NSMutableDictionary *)views {
    if (_views == nil) {
        _views = [[NSMutableDictionary alloc] init];
    }
    return _views;
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


-(UIImageView *)oldImage {
    if (_oldImage == nil) {
        _oldImage = [[UIImageView alloc] init];
    }
    return _oldImage;
}

-(UIImageView *)currentImage {
    if (_currentImage == nil) {
        _currentImage = [[UIImageView alloc] init];
    }
    return _currentImage;
}

-(UILabel *)buildingInfo {
    if (_buildingInfo == nil) {
        _buildingInfo = [[UILabel alloc] init];
    }
    return _buildingInfo;
}

-(UILabel *)buildingLabel {
    if (_buildingLabel == nil) {
        _buildingLabel = [[UILabel alloc] init];
    }
    return _buildingLabel;
}

-(UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] init];
    }
    return _menuButton;
}

@end
