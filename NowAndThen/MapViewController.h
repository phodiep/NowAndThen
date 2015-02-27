//
//  MapViewController.h
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildingViewController.h"

@interface MapViewController : UIViewController

@property (weak, nonatomic) BuildingViewController *buildingVC;
@property (strong, nonatomic) NSMutableDictionary *buildingsOnMap;
@property (strong, nonatomic) NSString *buildingForSearch;
-(void)centerOnBuilding:(Building*)building;

@end
