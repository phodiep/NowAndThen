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

@interface MapViewController () <MKMapViewDelegate, UIToolbarDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *centerOnUser;
-(IBAction)centerOnUser:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *findPortals;
-(IBAction)findPortals:(id)sender;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *findBuildings;
-(IBAction)findBuildings:(id)sender;

@property (strong, nonatomic) UIToolbar *toolBar;
@property (nonatomic, copy) NSArray *toolBarItems;

-(void)createViews;
-(void)createConstraints;
//-(void)addVisualConstraints:(NSString *)viewString forViews:(NSDictionary *)views;
@end

@implementation MapViewController

//when leaving the mapview - allow the user to chose to update the maps location if they move


#pragma mark - UIViewController Lifecycle
- (void)loadView
{
  self.mapView.delegate = self;
  self.toolBar.delegate = self;
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
  
  NSLog(@"%lu",(unsigned long)self.toolBarItems.count);
}

- (void)viewDidAppear:(BOOL)animated
{
  CLLocationCoordinate2D startLocation;
 // startLocation.latitude = self.mapView.userLocation.coordinate.latitude;
 // startLocation.longitude = self.mapView.userLocation.coordinate.longitude;
  startLocation.latitude = 47.6204;    //TODO: these are just temp variables due to simulator issues
  startLocation.longitude = -122.3491;
  MKCoordinateRegion startRegion = MKCoordinateRegionMakeWithDistance(startLocation, 750, 750);
  
  [UIView animateWithDuration:2.5 animations:^{
    self.mapView.alpha = 1.0;
   [self.mapView setRegion:startRegion];
  }];
}

#pragma mark - CoreLocation
- (void)setupCoreLocationAuthorization
{
  NSLog(@"coreLocation");
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
#pragma toolBar button actions
-(IBAction)centerOnUser:(id)sender
{
  NSLog(@"center on user");
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
  NSLog(@"get buildings for map area");
}

#pragma createViews
- (void)createViews
{
  [self.toolBar setTranslatesAutoresizingMaskIntoConstraints:false];
  
  [self.mapView addSubview:self.toolBar];
  
  [self.toolBar setItems:self.toolBarItems animated:true];
  
}

#pragma createConstraints
- (void)createConstraints
{
  NSDictionary *views = @{@"toolBar":self.toolBar}; //, @"centerOnUser":self.centerOnUser};

  
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[toolBar]-10-|"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-15-[toolBar]"
                                                                       options:0
                                                                       metrics:nil
                                                                         views:views]];
}


//#pragma addVisualConstraints
//- (void)addVisualConstraints:(NSString *)viewString forViews:(NSDictionary *)views
//{
//  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:viewString
//                                                                    options:0
//                                                                    metrics:0
//                                                                      views:views]];
//   
//}

@end
