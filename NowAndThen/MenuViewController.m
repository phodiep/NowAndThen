//
//  MenuViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MenuViewController.h"
#import "BuildingViewController.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) UISearchBar *searchBar;
@property (strong, nonatomic) BuildingViewController *buildingVC;

@end

@implementation MenuViewController

-(void)loadView {
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor whiteColor];
    
    [self.searchBar setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [self.tableView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [rootView addSubview:self.searchBar];
    [rootView addSubview:self.tableView];

    NSDictionary *views = @{ @"tableView":self.tableView,
                             @"searchBar":self.searchBar};
    
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[searchBar]-[tableView]|" options:0 metrics:nil views: views]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[searchBar(250)]-(>=0)-|" options:0 metrics:nil views: views]];
    [rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[tableView(250)]-(>=0)-|" options:0 metrics:nil views: views]];
    
    self.view = rootView;
    
    self.buildingVC = [[BuildingViewController alloc] init];
    
    [self addChildViewController:self.buildingVC];
    [self.view addSubview:self.buildingVC.view];
    [self.buildingVC didMoveToParentViewController:self];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.results = @[@"Smith Tower", @"Columbia Tower", @"Dexter Horton Building"];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchBar.delegate = self;
    [self.tableView registerClass:UITableViewCell.class forCellReuseIdentifier:@"MENU_CELL"];
    
    
}

#pragma mark - UITableViewDataSource
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

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.searchBar resignFirstResponder];
    self.buildingVC.buildingLabel.text = self.results[indexPath.row];
    self.buildingVC.buildingName = self.results[indexPath.row];
    //TODO - pass over new building
    [self.buildingVC closePanel];
}


#pragma mark - UISearchBarDelegate
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [self.searchBar setShowsCancelButton:true];
    return true;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
    [self.searchBar setShowsCancelButton:false];
}

#pragma mark - Lazy Loading Getters
-(UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
    }
    return _tableView;
}

-(UISearchBar *)searchBar {
    if (_searchBar == nil) {
        _searchBar = [[UISearchBar alloc] init];
    }
    return _searchBar;
}

@end
