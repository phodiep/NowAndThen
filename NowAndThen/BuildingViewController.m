//
//  BuildingViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "BuildingViewController.h"

@interface BuildingViewController ()

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIImageView *oldImage;
@property (strong, nonatomic) UIImageView *currentImage;
@property (strong, nonatomic) UILabel *buildingLabel;
@property (strong, nonatomic) UILabel *buildingInfo;

@end

@implementation BuildingViewController

- (void)loadView {
    UIView *rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    
    CGFloat screenWidth = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
    CGFloat screenHeight = CGRectGetHeight([UIScreen mainScreen].applicationFrame) - 25;

    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 25, screenWidth, screenHeight);
    scrollView.contentSize = CGSizeMake(screenWidth, screenHeight);

    scrollView.bounces = true;
    
    [self setSampleView];
    
    self.buildingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    self.buildingInfo.font = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
    
    self.buildingInfo.numberOfLines = 0;
    self.buildingInfo.lineBreakMode = NSLineBreakByWordWrapping;
    
    [self setupObjectForAutoLayout: self.oldImage       addToSubView:scrollView  addToDictionary:@"oldImage"];
    [self setupObjectForAutoLayout: self.currentImage   addToSubView:scrollView  addToDictionary:@"currentImage"];
    [self setupObjectForAutoLayout: self.buildingLabel  addToSubView:scrollView  addToDictionary:@"buildingLabel"];
    [self setupObjectForAutoLayout: self.buildingInfo   addToSubView:scrollView  addToDictionary:@"buildingInfo"];
    
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[buildingLabel]-8-[buildingInfo]-8-[oldImage]-[currentImage]-|" options:0 metrics:nil views:self.views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildingLabel]-8-|" options:0 metrics:nil views:self.views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[oldImage]-8-|" options:0 metrics:nil views:self.views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[currentImage]-8-|" options:0 metrics:nil views:self.views]];
    [scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildingInfo(width)]-8-|" options:0 metrics:@{@"width": @(screenWidth - 16) } views:self.views]];
    
    [rootView addSubview:scrollView];
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Building";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
}


-(void)setSampleView {
    self.oldImage.image = [UIImage imageNamed:@"smithTowerOld"];
    self.oldImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.currentImage.image = [UIImage imageNamed:@"smithTowerNew"];
    self.currentImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.buildingLabel.text = @"Smith Tower";
    
    self.buildingInfo.text = @"Smith Tower is a skyscraper in Pioneer Square in Seattle, Washington. Completed in 1914, the 38-story, 149 m (489 ft) tower is the oldest skyscraper in the city and was the tallest office building west of the Mississippi River until the Kansas City Power & Light Building was built in 1931. It remained the tallest building on the West Coast until the Space Needle overtook it in 1962. \n\nSmith Tower is named after its builder, firearm and typewriter magnate Lyman Cornelius Smith, and is a designated Seattle landmark.";


}

-(void)setupObjectForAutoLayout:(id)object addToSubView:(UIView*)view addToDictionary:(NSString*)reference {

    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
    
}


#pragma mark - Lazy Loading Getters
-(NSMutableDictionary *)views {
    if (_views == nil) {
        _views = [[NSMutableDictionary alloc] init];
    }
    return _views;
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

@end
