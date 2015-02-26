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
#import "ImageCell.h"
#import "WebViewController.h"
#import "MapViewController.h"

#pragma mark - Interface
@interface BuildingViewController () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIView *rootView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (strong, nonatomic) UIView *moreMenuView;

@property (strong, nonatomic) UICollectionView *imageCollectionView;
@property (strong, nonatomic) NSMutableArray *images;
@property (nonatomic) BOOL firstScrollCollectionView;

@property (strong, nonatomic) UIButton *menuButton;
@property (strong, nonatomic) UITapGestureRecognizer *tapToClose;

@property (strong, nonatomic) UIButton *moreButton;
@property (nonatomic) BOOL moreMenuShowing;
@property (strong, nonatomic) UITapGestureRecognizer *tapOffMoreMenu;

@property (strong, nonatomic) UIButton *mapButton;

@property (strong, nonatomic) UIButton *googleButton;
@property (strong, nonatomic) UIButton *yahooButton;
@property (strong, nonatomic) UIButton *wikipediaButton;

#pragma mark - Labels
@property (strong, nonatomic) UILabel *addressLabel;
@property (strong, nonatomic) UILabel *buildLabel;
@property (strong, nonatomic) UILabel *completionLabel;
@property (strong, nonatomic) UILabel *crossEWLabel;
@property (strong, nonatomic) UILabel *crossNSLabel;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UILabel *buildingInfo;
@property (strong, nonatomic) UILabel *address;
@property (strong, nonatomic) UILabel *cityStateZip;
@property (strong, nonatomic) UILabel *buildDate;
@property (strong, nonatomic) UILabel *completionDate;
@property (strong, nonatomic) UILabel *crossStreetEW;
@property (strong, nonatomic) UILabel *crossStreetNS;

@end

#pragma mark - Implementation
@implementation BuildingViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    self.firstScrollCollectionView = false;

    self.scrollView.frame = CGRectMake(0, 0, CGRectGetWidth([[UIScreen mainScreen] applicationFrame]), CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
    self.scrollView.bounces = true;
    self.scrollView.backgroundColor = [UIColor whiteColor];
    
    [self setupImageCollectionView];
    
    self.buildingInfo.numberOfLines = 0;
    self.buildingInfo.lineBreakMode = NSLineBreakByWordWrapping;

    [self.menuButton setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(menuButtonPressed) forControlEvents:UIControlEventTouchUpInside];

    [self.moreButton setImage:[UIImage imageNamed:@"more"] forState:UIControlStateNormal];
    [self.moreButton addTarget:self action:@selector(moreButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.mapButton setImage:[UIImage imageNamed:@"location"] forState:UIControlStateNormal];
    [self.mapButton addTarget:self action:@selector(mapButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.googleButton setImage:[UIImage imageNamed:@"google"] forState:UIControlStateNormal];
    [self.googleButton addTarget:self action:@selector(googleButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.wikipediaButton setImage:[UIImage imageNamed:@"wikipedia"] forState:UIControlStateNormal];
    [self.wikipediaButton addTarget:self action:@selector(wikipediaButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self.yahooButton setImage:[UIImage imageNamed:@"yahoo"] forState:UIControlStateNormal];
    [self.yahooButton addTarget:self action:@selector(yahooButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    
    [self prepareScrollViewForAutolayout];
    [self applyAutolayoutConstraintsToScrollView];


    [self setupAutolayoutForRootView];
    [self setupAutolayoutForMoreMenuView];

    self.view = self.rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.moreMenuShowing = NO;
    
    [self setBuildingLabelValues];
    
    self.imageCollectionView.dataSource = self;
    self.imageCollectionView.delegate = self;
    [self.imageCollectionView registerClass:ImageCell.class forCellWithReuseIdentifier:@"IMAGE_CELL"];
    
    self.tapToClose = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePanel)];
    self.tapOffMoreMenu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideMoreMenu)];

    //used to update which building is displayed
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self
                           selector:@selector(updateBuilding:)
                               name:@"SelectedBuilding"
                             object:nil];
}

-(void)viewWillAppear:(BOOL)animated {
    [self hideMoreMenu];
}

-(void)viewDidLayoutSubviews {
    if (self.firstScrollCollectionView == false) {
        [self.imageCollectionView scrollToItemAtIndexPath: [NSIndexPath indexPathForItem:5 inSection:0]
                                     atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:false];
        self.firstScrollCollectionView = true;
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    //reset autolayout constraints when screen is rotated
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self applyAutolayoutConstraintsToScrollView];
        [self hideMoreMenu];
    } completion:nil];
}

-(void)dealloc {
    //removes self as listner
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)setupImageCollectionView {
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    self.imageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    self.imageCollectionView.pagingEnabled = false;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.itemSize = CGSizeMake(300,300);
    [layout setSectionInset:UIEdgeInsetsMake(0,0,0,0)];
}

-(void)setBuildingLabelValues {
    [self applyLabelFormat:self.addressLabel    setText:@"Address"];
    [self applyLabelFormat:self.buildLabel      setText:@"Build Date"];
    [self applyLabelFormat:self.completionLabel setText:@"Completion Date"];
    [self applyLabelFormat:self.crossEWLabel    setText:@"Cross Streets East/West"];
    [self applyLabelFormat:self.crossNSLabel    setText:@"Cross Streets North/South"];
    [self applyLabelFormat:self.infoLabel       setText:@"More Information"];
    
    [self applyTextFormat:self.buildingLabel    setText:self.building.name];
    [self applyTextFormat:self.address          setText:self.building.address];
    [self applyTextFormat:self.cityStateZip     setText:[NSString stringWithFormat:@"%@ %@, %@", self.building.city, self.building.state, self.building.zipcode]];
    [self applyTextFormat:self.buildDate        setText:self.building.buildDate];
    [self applyTextFormat:self.completionDate   setText:self.building.buildCompletion];
    [self applyTextFormat:self.crossStreetEW    setText:self.building.crossStreetEastWest];
    [self applyTextFormat:self.crossStreetNS    setText:self.building.crossStreetNorthSouth];
    [self applyTextFormat:self.buildingInfo     setText:@"Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda."];
    
    //TODO: update placeholder images with real images from building object
    [self.images addObject: [UIImage imageNamed:@"smithTowerOld"]];
    [self.images addObject: [UIImage imageNamed:@"smithTowerNew"]];
    
    self.buildingLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:20.0f];
}

#pragma mark - Apply Label and Text Formats
-(void)applyLabelFormat:(UILabel*)label setText:(NSString*)text {
    label.text = text;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:14.0f];
    label.textColor = [UIColor grayColor];
}

-(void)applyTextFormat:(UILabel*)label setText:(NSString*)text {
    label.text = text;
    label.font = [UIFont fontWithName:@"HelveticaNeue" size:16.0f];
}

#pragma mark - Autolayout methods
-(void)prepObjectForAutoLayout:(id)object addToSubView:(UIView*)view addToDictionary:(NSString*)reference {
    [object setTranslatesAutoresizingMaskIntoConstraints:false];
    [view addSubview:object];
    [self.views setObject:object forKey:reference];
}

-(void)setupAutolayoutForRootView {
    [self prepObjectForAutoLayout: self.scrollView     addToSubView:self.rootView  addToDictionary:@"scrollView"];
    [self prepObjectForAutoLayout: self.buildingLabel  addToSubView:self.rootView  addToDictionary:@"buildingLabel"];
    [self prepObjectForAutoLayout: self.menuButton     addToSubView:self.rootView  addToDictionary:@"menuButton"];
    
    [self prepObjectForAutoLayout: self.moreButton     addToSubView:self.rootView  addToDictionary:@"moreButton"];
    
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[scrollView]|"                              options:0 metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[menuButton]-16-[buildingLabel]-(>=8)-[moreButton]-8-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-25-[menuButton]-8-[scrollView]|"           options:0 metrics:nil views:self.views]];
}

-(void)setupAutolayoutForMoreMenuView {
    self.moreMenuView.backgroundColor = [UIColor lightGrayColor];
    self.moreMenuView.alpha = 0.75;
    [self prepObjectForAutoLayout:self.moreMenuView         addToSubView:self.rootView      addToDictionary:@"moreView"];
    
    [self prepObjectForAutoLayout:self.mapButton            addToSubView:self.moreMenuView  addToDictionary:@"mapButton"];
    [self prepObjectForAutoLayout:self.googleButton         addToSubView:self.moreMenuView  addToDictionary:@"google"];
    [self prepObjectForAutoLayout:self.yahooButton          addToSubView:self.moreMenuView  addToDictionary:@"yahoo"];
    [self prepObjectForAutoLayout:self.wikipediaButton      addToSubView:self.moreMenuView  addToDictionary:@"wikipedia"];
    
    [self.moreMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[mapButton(34)]-16-[google(34)]-16-[wikipedia(34)]-16-[yahoo(34)]-8-|"               options:NSLayoutFormatAlignAllCenterX metrics:nil     views:self.views]];

    [self.moreMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[mapButton(34)]-8-|"               options:NSLayoutFormatAlignAllCenterY metrics:nil     views:self.views]];
    [self.moreMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[google(34)]-8-|"               options:NSLayoutFormatAlignAllCenterY metrics:nil     views:self.views]];
    [self.moreMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[wikipedia(34)]-8-|"               options:NSLayoutFormatAlignAllCenterY metrics:nil     views:self.views]];
    [self.moreMenuView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[yahoo(34)]-8-|"               options:NSLayoutFormatAlignAllCenterY metrics:nil     views:self.views]];

    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[moreView]-(-50)-|"               options:0 metrics:nil     views:self.views]];
    [self.rootView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[moreView]"               options:0 metrics:nil     views:self.views]];
}

-(void)prepareScrollViewForAutolayout {
    [self prepObjectForAutoLayout: self.buildingInfo        addToSubView:self.scrollView  addToDictionary:@"buildingInfo"];
    [self prepObjectForAutoLayout: self.imageCollectionView addToSubView:self.scrollView  addToDictionary:@"imageFlow"];
    [self prepObjectForAutoLayout: self.address             addToSubView:self.scrollView  addToDictionary:@"address"];
    [self prepObjectForAutoLayout: self.cityStateZip        addToSubView:self.scrollView  addToDictionary:@"cityStateZip"];
    [self prepObjectForAutoLayout: self.buildDate           addToSubView:self.scrollView  addToDictionary:@"buildDate"];
    [self prepObjectForAutoLayout: self.completionDate      addToSubView:self.scrollView  addToDictionary:@"completionDate"];
    [self prepObjectForAutoLayout: self.crossStreetEW       addToSubView:self.scrollView  addToDictionary:@"crossEW"];
    [self prepObjectForAutoLayout: self.crossStreetNS       addToSubView:self.scrollView  addToDictionary:@"crossNS"];
    [self prepObjectForAutoLayout: self.addressLabel        addToSubView:self.scrollView  addToDictionary:@"addressLabel"];
    [self prepObjectForAutoLayout: self.buildLabel          addToSubView:self.scrollView  addToDictionary:@"buildLabel"];
    [self prepObjectForAutoLayout: self.completionLabel     addToSubView:self.scrollView  addToDictionary:@"completionLabel"];
    [self prepObjectForAutoLayout: self.crossEWLabel        addToSubView:self.scrollView  addToDictionary:@"crossEWLabel"];
    [self prepObjectForAutoLayout: self.crossNSLabel        addToSubView:self.scrollView  addToDictionary:@"crossNSLabel"];
    [self prepObjectForAutoLayout: self.infoLabel           addToSubView:self.scrollView  addToDictionary:@"infoLabel"];
}

-(void)applyAutolayoutConstraintsToScrollView {
    NSDictionary *metrics = @{@"width": @(CGRectGetWidth([[UIScreen mainScreen] applicationFrame]) - 16)};
    [self.scrollView removeConstraints:[self.scrollView constraints]];
    
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[addressLabel]-[address]-[cityStateZip]-25-[buildLabel]-[buildDate]-[completionLabel]-[completionDate]-25-[crossNSLabel]-[crossNS]-[crossEWLabel]-[crossEW]-25-[infoLabel]-[buildingInfo]-25-[imageFlow(300)]-50-|" options:0 metrics:nil views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[addressLabel]-8-|"      options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[address]-8-|"           options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[cityStateZip]-8-|"      options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildLabel]-8-|"        options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildDate]-8-|"         options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[completionLabel]-8-|"   options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[completionDate]-8-|"    options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[crossNSLabel]-8-|"      options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[crossNS]-8-|"           options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[crossEWLabel]-8-|"      options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[crossEW]-8-|"           options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[infoLabel]-8-|"         options:0 metrics:nil     views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[buildingInfo(width)]-|" options:0 metrics:metrics views:self.views]];
    [self.scrollView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[imageFlow]|"               options:0 metrics:nil     views:self.views]];

}


#pragma mark - UICollectionViewFlowDelegate
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if ([self.images count] > 0) {
//        return [self.images count];
        return 10;
    }
    return 0;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageCell *cell = (ImageCell*)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:@"IMAGE_CELL" forIndexPath:indexPath];
    int index = (int)(indexPath.row % [self.images count]);
    cell.imageView.image = self.images[index];
    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
    return cell;
}


#pragma mark - Button Actions
-(void)menuButtonPressed {
    __weak BuildingViewController *weakSelf = self;
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.view.center = CGPointMake(weakSelf.view.center.x + 250, weakSelf.view.center.y);
    } completion:^(BOOL finished) {
        [self hideMoreMenu];
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

-(void)moreButtonPressed {
    if (self.moreMenuShowing) {
        [self hideMoreMenu];
    } else {
        [self showMoreMenu];
    }
}

-(void)showMoreMenu {
    if (self.moreMenuShowing == NO) {
        __weak BuildingViewController *weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.moreMenuView.center = CGPointMake(weakSelf.moreMenuView.center.x - 50, weakSelf.moreMenuView.center.y);
        } completion:^(BOOL finished) {
            weakSelf.moreMenuShowing = YES;
            [weakSelf.view addGestureRecognizer:weakSelf.tapOffMoreMenu];
        }];
    }
}

-(void)hideMoreMenu {
    if (self.moreMenuShowing == YES) {
        __weak BuildingViewController *weakSelf = self;
        [UIView animateWithDuration:0.3 animations:^{
            weakSelf.moreMenuView.center = CGPointMake(weakSelf.moreMenuView.center.x + 50, weakSelf.moreMenuView.center.y);
        } completion:^(BOOL finished) {
            weakSelf.moreMenuShowing = NO;
            [weakSelf.view removeGestureRecognizer:weakSelf.tapOffMoreMenu];
        }];
    }
}

-(void)scrollToTopOfView {
    [self.scrollView setContentOffset:CGPointMake(0, -self.scrollView.contentInset.top) animated:true];
}

-(void)mapButtonPressed {
    [self transitionToMapViewController];
}

-(void)transitionToMapViewController {
    int tabIndex = 1;
    
    UITabBarController *tabBarController = self.tabBarController;
    UIView *fromView = tabBarController.selectedViewController.view;
    UIView *toView = [[tabBarController.viewControllers objectAtIndex:tabIndex] view];
    MapViewController *toVC = [tabBarController.viewControllers objectAtIndex:tabIndex];
    
    [UIView transitionFromView:fromView toView:toView duration:0.5
                       options:(tabIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionFlipFromTop : UIViewAnimationOptionTransitionCrossDissolve)
                    completion:^(BOOL finished) {
                        if (finished) {
                            tabBarController.selectedIndex = tabIndex;
                            [toVC centerOnBuilding:self.building];
                        }
                    }];
}

-(void)presentWebViewWithUrl:(NSString*)url {
    WebViewController *webVC = [[WebViewController alloc] init];
    webVC.link = url;
    [self presentViewController:webVC animated:true completion:nil];
}

-(void)googleButtonPressed {
    [self presentWebViewWithUrl:self.building.googleURL];
}

-(void)yahooButtonPressed {
    [self presentWebViewWithUrl:self.building.yahooURL];
}

-(void)wikipediaButtonPressed {
    [self presentWebViewWithUrl:self.building.wikipediaURL];
}


#pragma updateBuildingName
- (void)updateBuildingName:(NSNotification *)notification {
  self.buildingName = [notification userInfo][@"Building"];
  self.buildingLabel.text = [notification userInfo][@"Building"];
}

#pragma mark - transition from Map -> Building... update Building object
-(void)updateBuilding:(NSNotification *)notification {
    self.building = [notification userInfo][@"Building"];
    [self setBuildingLabelValues];
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

-(UIView *)moreMenuView {
    if (_moreMenuView == nil) {
        _moreMenuView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
    }
    return _moreMenuView;
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

-(UIButton *)moreButton {
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
    }
    return _moreButton;
}

-(UIButton *)menuButton {
    if (_menuButton == nil) {
        _menuButton = [[UIButton alloc] init];
    }
    return _menuButton;
}

-(UIButton *)mapButton {
    if (_mapButton == nil) {
        _mapButton = [[UIButton alloc] init];
    }
    return _mapButton;
}
-(UIButton *)googleButton {
    if (_googleButton == nil) {
        _googleButton = [[UIButton alloc] init];
    }
    return _googleButton;
}

-(UIButton *)yahooButton {
    if (_yahooButton == nil) {
        _yahooButton = [[UIButton alloc] init];
    }
    return _yahooButton;
}

-(UIButton *)wikipediaButton {
    if (_wikipediaButton == nil) {
        _wikipediaButton = [[UIButton alloc] init];
    }
    return _wikipediaButton;
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

-(UILabel *)addressLabel {
    if (_addressLabel == nil) {
        _addressLabel = [[UILabel alloc] init];
    }
    return _addressLabel;
}

-(UILabel *)buildLabel {
    if (_buildLabel == nil) {
        _buildLabel = [[UILabel alloc] init];
    }
    return _buildLabel;
}

- (UILabel *)completionLabel {
    if (_completionLabel == nil) {
        _completionLabel = [[UILabel alloc] init];
    }
    return _completionLabel;
}

-(UILabel *)crossEWLabel {
    if (_crossEWLabel == nil) {
        _crossEWLabel = [[UILabel alloc] init];
    }
    return _crossEWLabel;
}

-(UILabel *)crossNSLabel {
    if (_crossNSLabel == nil) {
        _crossNSLabel = [[UILabel alloc] init];
    }
    return _crossNSLabel;
}

-(UILabel *)infoLabel {
    if (_infoLabel == nil) {
        _infoLabel = [[UILabel alloc] init];
    }
    return _infoLabel;
}


@end
