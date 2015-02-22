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

@end

@implementation MapViewController

#pragma mark - UIViewController Lifecycle
- (void)loadView {
    
    self.mapView.frame = [[UIScreen mainScreen] bounds];
    
    self.view = self.mapView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"MapView";
    
    [self setupCoreLocationAuthorization];
}

#pragma mark - CoreLocation
- (void)setupCoreLocationAuthorization {
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestWhenInUseAuthorization];
    } else {
        self.mapView.showsUserLocation = true;
        [self.locationManager startUpdatingLocation];
    }
    
}

#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion mapRegion;
    mapRegion.center = self.mapView.userLocation.coordinate;
    mapRegion.span.latitudeDelta = 0.6;
    mapRegion.span.longitudeDelta = 0.6;
    
    [self.mapView setRegion:mapRegion animated:true];
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

@end
