//
//  Photos+Annotation.m
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Photos+Annotation.h"

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
  MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"photo"];
  
  view.enabled = true;
  view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  view.canShowCallout = true;
  view.image = [UIImage imageNamed:@"location"];
  
  return view;
}


@end
