//
//  MapViewController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController () <MKMapViewDelegate, UIToolbarDelegate, UIPopoverPresentationControllerDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *centerOnUser;
-(IBAction)centerOnUser:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *findPortals;
-(IBAction)findPortals:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *findBuildings;
-(IBAction)findBuildings:(id)sender;

@property (strong, nonatomic) IBOutlet MKUserTrackingBarButtonItem *trackUser;

@property (strong, nonatomic) UIToolbar *toolBar;
@property (strong, nonatomic) UIToolbar *trackingBar;

@property (nonatomic, copy) NSArray *toolBarItems;
@property (nonatomic, copy) NSArray *userTrackingItem;

@property (strong, nonatomic) UIAlertController *buildingSnapShot;

-(void)createViews;
-(void)createConstraints;
-(void)transitionToBuildingDetail;
//custom method for setting locations
-(CLLocationCoordinate2D)createBuildingLocation:(double)latitude
                                  withLongitude:(double)longitude
                                 withIdentifier:(NSString *)name;

@end

@implementation MapViewController

//when leaving the mapview - allow the user to chose to update the maps location if they move


#pragma mark - UIViewController Lifecycle
- (void)loadView
{
  self.mapView.delegate = self;
  self.toolBar.delegate = self;
  self.trackingBar.delegate = self;
  self.mapView.frame = [[UIScreen mainScreen] bounds];
  self.view          = self.mapView;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = @"MapView";
  
  [self setupCoreLocationAuthorization];
  self.mapView.alpha = 0;
  [self createViews];
  [self createConstraints];
  
  CLLocationCoordinate2D startLocation;
  // startLocation.latitude = self.mapView.userLocation.coordinate.latitude;
  // startLocation.longitude = self.mapView.userLocation.coordinate.longitude;
  startLocation.latitude = 47.6204;    //TODO: these are just temp variables due to simulator issues
  startLocation.longitude = -122.3491;
  MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(startLocation, 750, 750);
  
  [UIView animateWithDuration:.5 animations:^{
    self.mapView.alpha = 1.0;
    [self.mapView setRegion:startRegion];
  }];
}


- (void)viewDidAppear:(BOOL)animated
{

}


#pragma mark - CoreLocation
- (void)setupCoreLocationAuthorization
{
  if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined)
  {
    [self.locationManager requestWhenInUseAuthorization];
  } else {
    self.mapView.showsUserLocation = true;
    [self.locationManager startUpdatingLocation];
    [self.mapView setZoomEnabled:true];
    [self.mapView setScrollEnabled:true];
  }
}


#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  NSLog(@"mapviewDelegate");
  MKCoordinateRegion mapRegion;
  mapRegion.center = self.mapView.userLocation.coordinate;
  mapRegion.span.latitudeDelta = 0.6;
  mapRegion.span.longitudeDelta = 0.6;
    
  [self.mapView setRegion:mapRegion
                 animated:true];
}


#pragma mark - Lazy Loading Getters
-(MKMapView *)mapView
{
    if (_mapView == nil)
    {
        _mapView = [[MKMapView alloc] init];
    }
    return _mapView;
}

-(CLLocationManager *)locationManager
{
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

-(UIToolbar *)toolBar
{
  if(!_toolBar)
  {
    _toolBar = [[UIToolbar alloc] init];
  }
  return _toolBar;
}

-(UIToolbar *)trackingBar
{
  if(!_trackingBar)
  {
    _trackingBar = [[UIToolbar alloc] init];
  }
  return _trackingBar;
}

-(MKUserTrackingBarButtonItem *)trackUser
{
  if (!_trackUser)
  {
    _trackUser = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
    //[_trackUser setTarget:self];
    //[_trackUser setAction:@selector(track:)];
  }
  return _trackUser;
}

-(NSArray *)toolBarItems
{
  if (!_toolBarItems)
  {
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemFlexibleSpace
                                                                            target:nil
                                                                            action:nil];
    
    _toolBarItems = @[self.centerOnUser, spacer, self.findPortals, spacer, self.findBuildings];
  }
  return _toolBarItems;
}

-(NSArray *)userTrackingItem
{
  if (!_userTrackingItem)
  {
    _userTrackingItem = @[self.trackUser];
  }
  return _userTrackingItem;
}
-(UIBarButtonItem *)centerOnUser
{
  if (!_centerOnUser)
  {
    _centerOnUser = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash
                                                                  target:self
                                                                  action:@selector(centerOnUser:)];
  }
  return _centerOnUser;
}

-(UIBarButtonItem *)findPortals
{
  if (!_findPortals)
  {
    _findPortals = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize
                                                                 target:self
                                                                 action:@selector(findPortals:)];
  }
  return _findPortals;
}

-(UIBarButtonItem *)findBuildings
{
  if (!_findBuildings)
  {
    _findBuildings = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose
                                                                   target:self
                                                                   action:@selector(findBuildings:)];
  }
  return _findBuildings;
}

-(UIAlertController *)buildingSnapShot
{
  if (_buildingSnapShot)
  {
    _buildingSnapShot = [[UIAlertController alloc] init];
  }
  return _buildingSnapShot;
}


#pragma toolBar button actions
-(IBAction)centerOnUser:(id)sender
{
  CLLocationCoordinate2D userLocation;
  userLocation.latitude  = self.mapView.userLocation.coordinate.latitude;
  userLocation.longitude = self.mapView.userLocation.coordinate.longitude;
  
  MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(userLocation, 750, 750);
  
  [self.mapView setRegion:userRegion
                 animated:true];
}

-(IBAction)findPortals:(id)sender
{
  NSLog(@"get portals for map area");
}

-(IBAction)findBuildings:(id)sender
{
  MKPointAnnotation *point0 = [[MKPointAnnotation alloc] init];
  MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
  MKPointAnnotation *point2 = [[MKPointAnnotation alloc] init];

  NSArray *tempBuildings = @[@"Smith Tower", @"Columbia Tower", @"Dexter Horton Building"];
    
  point0.coordinate = [self createBuildingLocation: 47.6021
                                     withLongitude: -122.3318
                                    withIdentifier: tempBuildings[0]];
  point0.title = tempBuildings[0];
    
  point1.coordinate = [self createBuildingLocation: 47.604633
                                     withLongitude: -122.330698
                                    withIdentifier: tempBuildings[1]];
  point1.title = tempBuildings[1];
    
  point2.coordinate = [self createBuildingLocation: 47.6034693
                                     withLongitude: -122.3328106
                                    withIdentifier: tempBuildings[2]];
  point2.title = tempBuildings[2];
  
  [self.mapView addAnnotation:point0];
  [self.mapView addAnnotation:point1];
  [self.mapView addAnnotation:point2];
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  if ([annotation isEqual:self.mapView.userLocation])
  {
    return nil;
  }
  
  MKPinAnnotationView *annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                        reuseIdentifier:@"annotationView"];
  
  annotationView.pinColor       = MKPinAnnotationColorPurple;
  annotationView.animatesDrop   = true;
  annotationView.canShowCallout = true;
  
  annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  
  return annotationView;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                     calloutAccessoryControlTapped:(UIControl *)control
{
  MKPointAnnotation *annotation = view.annotation;
  annotation.title = view.annotation.title;
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedBuilding"
                                                      object:self
                                                    userInfo:@{@"Building" : view.annotation.title}];
  [self transitionToBuildingDetail];
  
}


#pragma createViews
- (void)createViews
{
  [self.toolBar setTranslatesAutoresizingMaskIntoConstraints:false];
  [self.trackingBar setTranslatesAutoresizingMaskIntoConstraints:false];
  
  [self.mapView addSubview:self.toolBar];
  [self.mapView addSubview:self.trackingBar];
  
  [self.toolBar setItems:self.toolBarItems animated:true];
  [self.trackingBar setItems:self.userTrackingItem animated:true];
}


#pragma createConstraints
- (void)createConstraints
{
  NSDictionary *views = @{@"toolBar" : self.toolBar, @"trackingBar" : self.trackingBar};

  //toolBar constraints
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[toolBar]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[toolBar(30)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
  
  //trackingBar constraints
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[trackingBar]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[trackingBar(30)]-50-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
}


#pragma createBuildingLocation
-(CLLocationCoordinate2D)createBuildingLocation:(double)latitude
                                  withLongitude:(double)longitude
                                 withIdentifier:(NSString *)name
{
  CLLocationCoordinate2D location;
  location.latitude = latitude;
  location.longitude = longitude;
  
  return location;
}

#pragma transitionToBuildingDetail
- (void)transitionToBuildingDetail
{
  int tabIndex = 0;
  
  UITabBarController *tabBarController = self.tabBarController;
  UIView *fromView = tabBarController.selectedViewController.view;
  UIView *toView = [[tabBarController.viewControllers objectAtIndex:tabIndex] view];
  
  [UIView transitionFromView:fromView
                      toView:toView
                    duration:0.5
                     options:(tabIndex > tabBarController.selectedIndex ? UIViewAnimationOptionTransitionCrossDissolve : UIViewAnimationOptionTransitionFlipFromBottom)
                  completion:^(BOOL finished) {
    if (finished)
    {
      tabBarController.selectedIndex = tabIndex;
    }
  }];
}
@end
