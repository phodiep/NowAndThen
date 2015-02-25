//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineViewController.h"

@interface SkylineViewController ()

    @property (strong, nonatomic) UIButton *building52Button;       // Columbia Tower
    @property (strong, nonatomic) UITapGestureRecognizer *tapedId;

@end

@implementation SkylineViewController

- (void)loadView {
    UIView *rootView = [[UIView alloc] init];
    
    rootView.frame = [[UIScreen mainScreen] bounds];
    UIImage *menuImage = [UIImage imageNamed:@"skyline01.jpeg"];
    [self.building52Button setImage:menuImage forState:UIControlStateNormal];
    [self.building52Button addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"clear_button.png"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0f, 0.0f, 15.0f, 15.0f)]; // Required for iOS7
//    theTextField.rightView = button;
//    theTextField.rightViewMode = UITextFieldViewModeWhileEditing;

    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"Skyline";
    self.view.backgroundColor = [UIColor grayColor];

}

#pragma updateBuildingName
- (void)updateBuildingName:(NSNotification *)notification {

    NSLog(@"updateBuildingName() %@", notification );
//    self.buildingName = [notification userInfo][@"Building"];
//    self.buildingLabel.text = [notification userInfo][@"Building"];
}

#pragma mark - Button Actions
-(void)menuButtonPressed {

    __weak SkylineViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x + 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.building52Button removeTarget:weakSelf action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.building52Button addTarget:weakSelf action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.view addGestureRecognizer:weakSelf.tapedId];

    }];
}

- (void)modifyClearButtonWithImage:(UIImage *)image;{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"clear-button"] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(0.0f, 0.0f, 15.0f, 15.0f)];
    [button addTarget:self action:@selector(clear:) forControlEvents:UIControlEventTouchUpInside];
//    self.rightView = button;
//    self.rightViewMode = UITextFieldViewModeWhileEditing;
}

-(IBAction)clear:(id)sender{
//    self.text = @"";
}

@end
