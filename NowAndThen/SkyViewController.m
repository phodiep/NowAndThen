//
//  SkyViewController.m
//  NowAndThen
//
//  Created by Gru on 02/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "SkyViewController.h"

@interface SkyViewController ()

@property (strong, nonatomic) UIAlertController *buildingIdentity;
- (IBAction)building52:(UIButton *)sender;

- (IBAction)spaceNeedle:(UIButton *)sender;
//- (IBAction)building52:(UIButton *)sender;
- (IBAction)building164:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UIImageView *skylineA;
@property (strong, nonatomic) IBOutlet UITextField *buildingInformation;

@end

@implementation SkyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)building52:(UIButton *)sender {
        NSLog(@"building52(NickName: Columbia Center)");
         sender.adjustsImageWhenHighlighted = true;
         // Columbia Center
        _buildingInformation.text = @"Columbia Center";
        _buildingInformation.textColor = UIColor.blackColor;
}

- (IBAction)spaceNeedle:(UIButton *)sender {
    NSLog(@"spaceNeedle(NickName: Space Needle)");
     sender.adjustsImageWhenHighlighted = true;
     // Space Needle, Seattle Center
    _buildingInformation.text = @"Space Needle, Seattle Center";
    _buildingInformation.textColor = UIColor.blackColor;
}

- (IBAction)building164:(UIButton *)sender {
    NSLog(@"building164(NickName: WAMU Tower)");
    sender.adjustsImageWhenHighlighted = true;
    // @"WAMU Tower";
    _buildingInformation.text = @"WAMU Tower";
    _buildingInformation.textColor = UIColor.blackColor; // UIColor *color = [UIColor whiteColor];
}

@end
