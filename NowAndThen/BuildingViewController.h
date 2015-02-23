//
//  BuildingViewController.h
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildingViewController : UIViewController

@property (strong, nonatomic) NSString *buildingName;
@property (strong, nonatomic) UILabel *buildingLabel;

-(void)closePanel;

@end
