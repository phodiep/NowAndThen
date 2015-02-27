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
#import "Building.h"
#import "NetworkController.h"
#import "Building+Annotation.h"
#import "Photos+Annotation.h"

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

@property (nonatomic) bool didLoadUserLocation;

//methods for setting up views
-(void)createViews;
-(void)createConstraints;

-(void)transitionToBuildingDetail;

////methods for getting the current screen region
-(CLLocationCoordinate2D)getCoordFromMapRectPoint:(double)X andY:(double)Y;
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mapRect;
-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mapRect;
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mapRect;
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mapRect;

-(NSArray *)getBoundingBox:(MKMapRect)mapRect;
-(NSArray *)getBoundingBoxForImages:(MKMapRect)mapRect;

//custom method for setting locations
-(CLLocationCoordinate2D)createBuildingLocation:(double)latitude
                                  withLongitude:(double)longitude
                                 withIdentifier:(NSString *)name;

//-(NSArray *)getCenterOfScreen:(MKMapRect)mapRect;

-(void)updateCalloutAccessoryImage:(MKAnnotationView *)annotationView;

@end

@implementation MapViewController

//when leaving the mapview - allow the user to chose to update the maps location if they move


#pragma mark - UIViewController Lifecycle
- (void)loadView
{
  self.view          = self.mapView;
  self.mapView.frame = [[UIScreen mainScreen] bounds];
  self.mapView.alpha = 0;
}


- (void)viewDidLoad
{
  [super viewDidLoad];
  // Do any additional setup after loading the view.
  self.title = @"MapView";
  
  [self setupCoreLocationAuthorization];
  [self createViews];
  [self createConstraints];
}


- (void)viewDidAppear:(BOOL)animated
{
  [UIView animateWithDuration:.9 animations:^{
    self.mapView.alpha = 1.0;
  }];
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

//this will refresh the view to center over the user sporadically
#pragma mark - MKMapViewDelegate
-(void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
  if (!self.didLoadUserLocation)
  {
    CLLocationCoordinate2D location;
    location.latitude = self.mapView.userLocation.coordinate.latitude;
    location.longitude = self.mapView.userLocation.coordinate.longitude;
  
    MKCoordinateRegion mapRegion = MKCoordinateRegionMakeWithDistance(location, 5000, 5000);

    
    [self.mapView setRegion:mapRegion
                   animated:true];
    self.didLoadUserLocation = true;
  }
}

-(void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
  //TODO: reenable search buttons, maybe....
}



#pragma methods for generating a bounding box -> to be used in geoJSON fetch
-(CLLocationCoordinate2D)getNWCoordinate:(MKMapRect)mapRect
{
  return [self getCoordFromMapRectPoint:mapRect.origin.x
                                   andY:mapRect.origin.y];
}

-(CLLocationCoordinate2D)getSECoordinate:(MKMapRect)mapRect
{
  return [self getCoordFromMapRectPoint:MKMapRectGetMaxX(mapRect)
                                   andY:MKMapRectGetMaxY(mapRect)];
}
-(CLLocationCoordinate2D)getNECoordinate:(MKMapRect)mapRect
{
  return [self getCoordFromMapRectPoint:MKMapRectGetMaxX(mapRect)
                                   andY:mapRect.origin.y];
}
-(CLLocationCoordinate2D)getSWCoordinate:(MKMapRect)mapRect
{
  return [self getCoordFromMapRectPoint:mapRect.origin.x
                                   andY:MKMapRectGetMaxY(mapRect)];
}

-(CLLocationCoordinate2D)getCoordFromMapRectPoint:(double)X andY:(double)Y
{
  MKMapPoint swMapPoint = MKMapPointMake(X, Y);
  return MKCoordinateForMapPoint(swMapPoint);
}

-(NSArray *)getBoundingBox:(MKMapRect)mapRect
{
  CLLocationCoordinate2D southEast  = [self getSECoordinate:mapRect];
  CLLocationCoordinate2D northWest  = [self getNWCoordinate:mapRect];
  
  return @[[NSNumber numberWithDouble:northWest.longitude],
           [NSNumber numberWithDouble:northWest.latitude],
           [NSNumber numberWithDouble:southEast.longitude],
           [NSNumber numberWithDouble:southEast.latitude]];
}

// this method returns a bounding box for Flickr fetch
-(NSArray *)getBoundingBoxForImages:(MKMapRect)mapRect
{
  CLLocationCoordinate2D northEast = [self getNECoordinate:mapRect];
  CLLocationCoordinate2D southWest = [self getSWCoordinate:mapRect];
  
  return @[[NSNumber numberWithDouble:southWest.longitude],
           [NSNumber numberWithDouble:southWest.latitude],
           [NSNumber numberWithDouble:northEast.longitude],
           [NSNumber numberWithDouble:northEast.latitude]];
}

-(NSArray *)getCenterOfScreen:(MKMapRect)mapRect
{
  MKMapPoint point = MKMapPointMake(mapRect.origin.x, mapRect.origin.y);
  CLLocationCoordinate2D location;
  location = MKCoordinateForMapPoint(point);
  
  
  NSLog(@"lat: %f, lon: %f", location.latitude, location.longitude);
  
  return @[[NSNumber numberWithDouble:location.latitude],
           [NSNumber numberWithDouble:location.longitude]];
}

#pragma mark - Lazy Loading Getters
-(MKMapView *)mapView
{
    if (_mapView == nil)
    {
      _mapView = [[MKMapView alloc] init];
      _mapView.delegate = self;
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
    _toolBar.delegate = self;
  }
  return _toolBar;
}

-(UIToolbar *)trackingBar
{
  if(!_trackingBar)
  {
    _trackingBar = [[UIToolbar alloc] init];
    _trackingBar.delegate = self;
  }
  return _trackingBar;
}

-(MKUserTrackingBarButtonItem *)trackUser
{
  if (!_trackUser)
  {
    _trackUser = [[MKUserTrackingBarButtonItem alloc] initWithMapView:self.mapView];
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


-(NSMutableDictionary *)buildingsOnMap
{
  if (!_buildingsOnMap)
  {
    _buildingsOnMap = [[NSMutableDictionary alloc] init];
  }
  return _buildingsOnMap;
}


#pragma mark - toolBar button actions
-(IBAction)centerOnUser:(id)sender
{
  CLLocationCoordinate2D userLocation;
  userLocation.latitude  = self.mapView.userLocation.coordinate.latitude;
  userLocation.longitude = self.mapView.userLocation.coordinate.longitude;
  
  MKCoordinateRegion userRegion = MKCoordinateRegionMakeWithDistance(userLocation, 750, 750);
  
  [self.mapView setRegion:userRegion
                 animated:true];
}

#pragma mark - centerOnBuilding
-(void)centerOnBuilding:(Building*)building {
    NSLog(@"long: %@ ... lat: %@", building.longitude, building.latitude);
    CLLocationCoordinate2D buildingLocation;
    buildingLocation.latitude = [building.latitude doubleValue];
    buildingLocation.longitude = [building.longitude doubleValue];
    
    MKCoordinateRegion buildingRegion = MKCoordinateRegionMakeWithDistance(buildingLocation, 750, 750);
    
    [self.mapView setRegion:buildingRegion animated:true];
    [self.mapView addAnnotation:building];
}

#pragma mark - create Annotations
-(IBAction)findPortals:(id)sender
{
  MKMapRect mapRect = self.mapView.visibleMapRect;
 
  self.mapView.alpha = 0.4;
  [[NetworkController sharedService] fetchFlickrImagesForBuilding:self.buildingForSearch
                                                  withBoundingBox:[self getBoundingBoxForImages:mapRect]
                                             andCompletionHandler:^(NSArray *images)
   {
     [self.mapView removeAnnotations:self.mapView.annotations];
     for (int i = 0; i < images.count; i++)
     {
       Photos *photoToAdd = (Photos *)images[i];
       [self.mapView addAnnotation:photoToAdd];
     }
     [UIView animateWithDuration:1.0 animations:^{
       self.mapView.alpha = 1.0;
     }];
      
     //[self.mapView showAnnotations:self.mapView.annotations animated:true];
  }];
}

//         findBuildings
-(IBAction)findBuildings:(id)sender
{
  [self.mapView removeAnnotations:self.mapView.annotations];

  MKMapRect mapRect = self.mapView.visibleMapRect;
  self.mapView.alpha = 0.4;
  [[NetworkController sharedService] fetchBuildingsForRect:[self getBoundingBox:mapRect] withBuildingLimit:10 andBlock:^(NSArray *buildingsFound) {
    
    for (int i = 0; i < buildingsFound.count; i++)
    {
      Building *buildingToAdd = (Building *)buildingsFound[i];
      [self.buildingsOnMap setObject:buildingsFound[i] forKey:buildingToAdd.name];
      [self.mapView addAnnotation:buildingToAdd];
    }
    self.mapView.alpha = 1.0;
  }];
  
}


//pin selected
-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
  if ([view.annotation isKindOfClass:[Photos class]])
  {
    //Photos *photo = (Photos *)view.annotation;
    [self updateCalloutAccessoryImage:view];
  } else {
    Building *building = (Building *)view.annotation;
    self.buildingForSearch = building.name;
    [self updateCalloutAccessoryImage:view];
  }
}


-(void)updateCalloutAccessoryImage:(MKAnnotationView *)annotationView
{
  UIImageView *imageView = nil;
  
  if ([annotationView.leftCalloutAccessoryView isKindOfClass:[UIImageView class]])
  {
    imageView = (UIImageView *)annotationView.leftCalloutAccessoryView;
  }
  if (imageView)
  {
    Building *building = nil;
    if ([annotationView.annotation isKindOfClass:[Building class]])
    {
      building = (Building *)annotationView.annotation;
    } else if ([annotationView.annotation isKindOfClass:[Photos class]])
    {
      Photos *photo = nil;
      self.mapView.alpha = 0.3;
      [[NetworkController sharedService] fetchBuildingImage:photo.fullSizeImageURL withCompletionHandler:^(UIImage *image) {
        imageView.image = image;
        annotationView.leftCalloutAccessoryView = imageView;
        [annotationView reloadInputViews];
        Building *building = (Building *)self.buildingsOnMap[self.buildingForSearch];
        [building.imageCollection addObject:imageView.image];
        NSLog(@"fullsizeImageLoaded: %lu",(unsigned long)building.imageCollection.count);
      }];
    }
    if (building)
    {
      [[NetworkController sharedService] fetchBuildingImage:building.oldImageURL withCompletionHandler:^(UIImage *image) {
        imageView.image = image;
        annotationView.leftCalloutAccessoryView = imageView;
        [annotationView reloadInputViews];
      }];
    }
  }
}


-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
  static NSString *reuseID = @"NowAndThenAnnotations";
  
  MKAnnotationView *view = [self.mapView dequeueReusableAnnotationViewWithIdentifier:reuseID];
  
  if (annotation == self.mapView.userLocation)
  {
    return nil;
  }
  
  if (!view)
  {
    view = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                           reuseIdentifier:reuseID];

    view.canShowCallout = true;
    UIImageView *leftCalloutImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
    view.leftCalloutAccessoryView  = leftCalloutImage;
    view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  }
  return view;
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
                     calloutAccessoryControlTapped:(UIControl *)control
{
  Building *building = self.buildingsOnMap[view.annotation.title];
  [[NSNotificationCenter defaultCenter] postNotificationName:@"SelectedBuilding"
                                                      object:self
                                                    userInfo:@{@"Building" : building}];
  [self transitionToBuildingDetail];
    }
}



#pragma mark - createViews
- (void)createViews
{
  [self.toolBar setTranslatesAutoresizingMaskIntoConstraints:false];
  [self.trackingBar setTranslatesAutoresizingMaskIntoConstraints:false];
  
  [self.mapView addSubview:self.toolBar];
  [self.mapView addSubview:self.trackingBar];
  
  [self.toolBar setItems:self.toolBarItems animated:true];
  [self.trackingBar setItems:self.userTrackingItem animated:true];
}


#pragma mark - createConstraints
- (void)createConstraints
{
  NSDictionary *views = @{@"toolBar" : self.toolBar, @"trackingBar" : self.trackingBar};

  //toolBar constraints
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[toolBar]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];

  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[toolBar(40)]"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
  
  //trackingBar constraints
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[trackingBar]-5-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
  
  [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[trackingBar(40)]-50-|"
                                                                    options:0
                                                                    metrics:nil
                                                                      views:views]];
}


#pragma mark - createBuildingLocation
-(CLLocationCoordinate2D)createBuildingLocation:(double)latitude
                                  withLongitude:(double)longitude
                                 withIdentifier:(NSString *)name
{
  CLLocationCoordinate2D location;
  location.latitude = latitude;
  location.longitude = longitude;
  
  return location;
}

#pragma mark - transitionToBuildingDetail
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
