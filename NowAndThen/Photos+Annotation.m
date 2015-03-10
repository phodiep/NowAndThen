//
//  Photos+Annotation.m
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Photos+Annotation.h"
#import "NetworkController.h"

@implementation Photos (Annotation)

-(CLLocationCoordinate2D)coordinate
{
  //TODO: check if location data exists - for any of the images - then set all images with that location
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = [self.latitude doubleValue];
  coordinate.longitude = [self.longitude doubleValue];
  
  return coordinate;
}

-(NSString *)title
{
  NSString *title;
  title = self.tag;
  return title;
}

-(MKAnnotationView *)annotationView
{
  MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"PhotoAnnotation"];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
  
  view.leftCalloutAccessoryView = imageView;
  view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  view.enabled = true;
  view.canShowCallout = true;
  view.frame = CGRectMake(self.coordinate.latitude, self.coordinate.longitude, 50, 50);
  view.layer.cornerRadius = 10.0;
  [[NetworkController sharedService] fetchBuildingImage:self.fullSizeImageURL withCompletionHandler:^(UIImage *image) {
    self.thumbImageView.image = image;
    [view addSubview:self.thumbImageView];
    imageView.image = image;
  }];
  return view;
}


@end
