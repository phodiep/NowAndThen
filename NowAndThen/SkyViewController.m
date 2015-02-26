//
//  SkyViewController.m
//  NowAndThen
//
//  Created by Gru on 02/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "SkyViewController.h"

@interface SkyViewController ()

@property (strong, nonatomic) UIAlertController *buildingIdentity;

- (IBAction)spaceNeedle:(UIButton *)sender;
- (IBAction)building52:(UIButton *)sender;
- (IBAction)building164:(UIButton *)sender;


@end

@implementation SkyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


- (IBAction)spaceNeedle:(UIButton *)sender {
    NSLog(@"spaceNeedle(NickName: Space Needle)");
}

- (IBAction)building52:(UIButton *)sender {
    NSLog(@"building52(NickName: Columbia Center)");
}

- (IBAction)building164:(UIButton *)sender {
    NSLog(@"building164(NickName: WAMU Tower)");
}

@end
