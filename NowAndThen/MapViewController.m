//
//  MapViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (void)loadView {
    UIView *rootView = [[UIView alloc] init];
    
    rootView.frame = [[UIScreen mainScreen] bounds];
    

    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MapView";
    self.view.backgroundColor = [UIColor greenColor];
    
}

@end
