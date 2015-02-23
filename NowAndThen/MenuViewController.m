//
//  MenuViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UITableView *tableView;

@end

@implementation MenuViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] init];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [rootView addSubview:self.tableView];

    NSDictionary *views = @{ @"tableView":self.tableView };
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[tableView]|" options:0 metrics:nil views: views]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-20-[tableView]|" options:0 metrics:nil views: views]];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.results = @[@"Smith Tower", @"Columbia Tower", @"Dexter Horton Building"];

    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.results count] >0 ) {
        return [self.results count];
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = (UITableViewCell*)[self.tableView dequeueReusableCellWithIdentifier:@"MENU_CELL" forIndexPath:indexPath];
    cell.textLabel.text = self.results[indexPath.row];
    return cell;
}


-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

@end
