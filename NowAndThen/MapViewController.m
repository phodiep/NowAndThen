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

@interface MapViewController () <MKMapViewDelegate>

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;

@property (weak, nonatomic) IBOutlet UIButton *centerOnUser;
-(IBAction)centerOnUser:(id)sender;


@end

@implementation MapViewController

//when leaving the mapview - allow the user to chose to update the maps location if they move


#pragma mark - UIViewController Lifecycle
- (void)loadView
{
  self.mapView.delegate = self;
  self.mapView.frame = [[UIScreen mainScreen] bounds];
  self.view          = self.mapView;
  
  //[self.mapView addSubview:self.centerOnUser];
  self.centerOnUser.backgroundColor = [UIColor blueColor];
  //[self.view addSubview:self.centerOnUser];
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = @"MapView";
  
  [self setupCoreLocationAuthorization];
  self.mapView.alpha = 0;
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
//  [self.mapView setRegion:startRegion];

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
-(MKMapView *)mapView {
    if (_mapView == nil) {
        _mapView = [[MKMapView alloc] init];
    }
    return _mapView;
}

-(CLLocationManager *)locationManager {
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
    }
    return _locationManager;
}

-(UIButton *)centerOnUser
{
  if (!_centerOnUser)
  {
    _centerOnUser = [[UIButton alloc] initWithFrame:CGRectMake(50, 50, 50, 50)];
  }
  return _centerOnUser;
}

-(IBAction)centerOnUser:(id)sender
{
  
}

@end
