//
//  MenuViewController.h
//  NowAndThen
//
//  Created by Pho Diep on 2/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuViewController : UIViewController

@property (strong, nonatomic) NSArray *results;
-(void)dismissSearchBarKeyboard;

@end
