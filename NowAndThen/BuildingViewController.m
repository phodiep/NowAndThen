//
//  BuildingViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BuildingViewController.h"
#import "MenuViewController.h"
#import "Building.h"

@interface BuildingViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic) CGFloat *screenWidth;
@property (nonatomic) CGFloat *screenHeight;

@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) NSMutableArray *images;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;

-(void)updateBuildingName:(NSNotification *)notification;


@property (strong, nonatomic) UILabel *buildingInfo;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *cityStateZip;
@property (strong, nonatomic) UILabel *buildDate;
@property (strong, nonatomic) UILabel *completionDate;
@property (strong, nonatomic) UILabel *crossStreetEW;
@property (strong, nonatomic) UILabel *crossStreetNS;

@end

@implementation BuildingViewController

- (void)loadView {
    
    

    self.scrollView.frame = CGRectMake(0, 0,
                                       CGRectGetWidth([[UIScreen mainScreen] applicationFrame]),
                                       CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
    
    self.scrollView.bounces = true;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self setupImageCollectionView];
    
    self.buildingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
    self.buildingInfo.font  = [UIFont fontWithName:@"HelveticaNeue-Thin" size:18.0f];
    
    self.buildingInfo.numberOfLines = 0;
    self.buildingInfo.lineBreakMode = NSLineBreakByWordWrapping;

    UIImage *menuImage = [UIImage imageNamed:@"menu"];
    [self.menuButton setImage:menuImage forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self setupAutolayoutForScrollView];
    [self setupAutolayoutConstraintsForScrollView];

    [self setupAutolayoutForRootView];
    [self setupAutolayoutConstraintsForRootView];

    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.buildingName;
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.imageCollectionView registerClass:UICollectionViewCell.class forCellWithReuseIdentifier:@"IMAGE_CELL"];
    
    self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];

    [self initBuildingLabels];
    [self setBuildingLabelValues];
  
  //used to update which building is displayed 
  NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
  [notificationCenter addObserver:self
                         selector:@selector(updateBuildingName:)
                             name:@"SelectedBuilding"
                           object:nil];

}


-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //reset autolayout constraints when screen is rotated
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {

        [self setupAutolayoutConstraintsForScrollView];
        
    } completion:nil];
}

-(void)setupAutolayoutForRootView {
    [self setupObjectForAutoLayout: self.scrollView     addToSubView:self.rootView  addToDictionary:@"scrollView"];
    [self setupObjectForAutoLayout: self.buildingLabel  addToSubView:self.rootView  addToDictionary:@"buildingLabel"];
    [self setupObjectForAutoLayout: self.menuButton     addToSubView:self.rootView  addToDictionary:@"menuButton"];
}

-(void)setupImageCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.imageCollectionView.pagingEnabled = true;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(300,300);
    [layout setSectionInset:UIEdgeInsetsMake(0,0,0,0)];
    
    
    [self.imageCollectionView setTranslatesAutoresizingMaskIntoConstraints:false];
    self.imageCollectionView.backgroundColor = [UIColor blackColor];
    [self.scrollView addSubview:self.imageCollectionView];
    
}

-(void)setupAutolayoutConstraintsForRootView {
    [self.rootView removeConstraints:[self.rootView constraints]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|" options:0 metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[menuButton]-16-[buildingLabel]-(>=0)-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[menuButton]-8-[scrollView]|" options:0 metrics:nil views:self.views]];

    
}

-(void)setupAutolayoutForScrollView {
    [self setupObjectForAutoLayout: self.buildingInfo        addToSubView:self.scrollView  addToDictionary:@"buildingInfo"];
    [self setupObjectForAutoLayout: self.imageCollectionView addToSubView:self.scrollView  addToDictionary:@"imageFlow"];

    [self setupObjectForAutoLayout: self.address             addToSubView:self.scrollView  addToDictionary:@"address"];
    [self setupObjectForAutoLayout: self.cityStateZip        addToSubView:self.scrollView  addToDictionary:@"cityStateZip"];
    [self setupObjectForAutoLayout: self.buildDate           addToSubView:self.scrollView  addToDictionary:@"buildDate"];
    [self setupObjectForAutoLayout: self.completionDate      addToSubView:self.scrollView  addToDictionary:@"completionDate"];
    [self setupObjectForAutoLayout: self.crossStreetEW       addToSubView:self.scrollView  addToDictionary:@"crossEW"];
    [self setupObjectForAutoLayout: self.crossStreetNS       addToSubView:self.scrollView  addToDictionary:@"crossNS"];
}

-(void)setupAutolayoutConstraintsForScrollView {
    [self.scrollView removeConstraints:[self.scrollView constraints]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[address]-[cityStateZip]-16-[buildDate]-[completionDate]-16-[crossEW]-[crossNS]-16-[buildingInfo]-20-[imageFlow(300)]-50-|"
                                                                            options:NSLayoutFormatAlignAllLeading metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[address]" options:0 metrics:nil views:self.views]];

    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildingInfo(width)]-|" options:0
                                                                            metrics: @{@"width": @(CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - 16) }
                                                                              views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageFlow]|" options:0 metrics:nil views:self.views]];
}

-(void)initBuildingLabels {
}

-(void)setBuildingLabelValues {
    self.buildingLabel.text = self.building.name;
    self.address.text = self.building.address;
    self.cityStateZip.text = [NSString stringWithFormat:@"%@ %@, %@",
                              self.building.city,
                              self.building.state,
                              self.building.zipcode];
    self.buildDate.text = [NSString stringWithFormat:@"Build Date: %@", self.building.buildDate];
    self.completionDate.text = [NSString stringWithFormat:@"CompetionDate : %@", self.building.buildCompletion];
    self.crossStreetEW.text = [NSString stringWithFormat:@"cross street E/W: %@", self.building.crossStreetEastWest];
    self.crossStreetNS.text = [NSString stringWithFormat:@"cross street N/S: %@", self.building.crossStreetNorthSouth];
    self.buildingInfo.text = @"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.";
    
    [self.images addObject: [UIImage imageNamed:@"smithTowerOld"]];
    [self.images addObject: [UIImage imageNamed:@"smithTowerNew"]];

}

-(void)setupBuildingInformation:(id)object getBuildingInfo:(Building*)building {

}

-(void)setupObjectForAutoLayout:(id)object addToSubView:(UIView*)view addToDictionary:(NSString*)reference {

    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
    
}

#pragma mark - UICollectionViewFlowDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.images count] > 0) {
        return [self.images count];
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = (UICollectionViewCell*)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:@"IMAGE_CELL" forIndexPath:indexPath];
    
    UIImageView *cellImage = [[UIImageView alloc] init];

    cellImage.image = self.images[indexPath.row];
    cellImage.contentMode = UIViewContentModeScaleAspectFit;
    
    [cellImage setTranslatesAutoresizingMaskIntoConstraints:false];
    [cell addSubview:cellImage];
    
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[image]|" options:0 metrics:nil views:@{@"image":cellImage}]];
    [cell addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[image]|" options:0 metrics:nil views:@{@"image":cellImage}]];
    
        
    return cell;
}


#pragma mark - Button Actions
-(void)menuButtonPressed {

    __weak BuildingViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x + 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.menuButton removeTarget:weakSelf action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.menuButton addTarget:weakSelf action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.view addGestureRecognizer:weakSelf.tapToClose];
        
    }];
}

-(void)closePanel {
    
    __weak BuildingViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x - 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [weakSelf.view removeGestureRecognizer:weakSelf.tapToClose];
        [weakSelf.menuButton removeTarget:weakSelf action:@selector(closePanel) forControlEvents:UIControlEventTouchUpInside];
        [weakSelf.menuButton addTarget:weakSelf action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    }];
}

#pragma updateBuildingName
- (void)updateBuildingName:(NSNotification *)notification
{
  self.buildingName = [notification userInfo][@"Building"];
  self.buildingLabel.text = [notification userInfo][@"Building"];
}

#pragma mark - Lazy Loading Getters
-(NSMutableDictionary *)views {
    if (_views == nil) {
        _views = [[NSMutableDictionary alloc] init];
    }
    return _views;
}

-(UIView *)rootView {
    if (_rootView == nil) {
        _rootView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    }
    return _rootView;
}

-(UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
    }
    return _scrollView;
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

-(UILabel *)address {
    if (_address == nil) {
        _address = [[UILabel alloc] init];
    }
    return _address;
}

-(UILabel *)cityStateZip {
    if (_cityStateZip == nil) {
        _cityStateZip = [[UILabel alloc] init];
    }
    return _cityStateZip;
}

-(UILabel *)buildDate {
    if (_buildDate == nil) {
        _buildDate = [[UILabel alloc] init];
    }
    return _buildDate;
}

-(UILabel *)completionDate {
    if (_completionDate == nil) {
        _completionDate = [[UILabel alloc] init];
    }
    return _completionDate;
}

-(UILabel *)crossStreetEW {
    if (_crossStreetEW == nil) {
        _crossStreetEW = [[UILabel alloc] init];
    }
    return _crossStreetEW;
}

-(UILabel *)crossStreetNS {
    if (_crossStreetNS == nil) {
        _crossStreetNS = [[UILabel alloc] init];
    }
    return _crossStreetNS;
}


-(UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] init];
    }
    return _menuButton;
}

-(UICollectionView *)imageCollectionView {
    if (_imageCollectionView == nil) {
        _imageCollectionView = [[UICollectionView alloc] init];
    }
    return _imageCollectionView;
}

-(NSMutableArray *)images {
    if (_images == nil) {
        _images = [[NSMutableArray alloc] init];
    }
    return _images;
}



//removes self as listner
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
