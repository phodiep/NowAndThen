//
//  Building+Annotation.m
//  NowAndThen
//
//  Created by Josh Kahl on 2/25/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Building+Annotation.h"

//@interface Building ()
//
//@property (nonatomic) MKPinAnnotationColor pinColor;
//
//@end

@implementation Building (Annotation)

-(CLLocationCoordinate2D)coordinate
{
  CLLocationCoordinate2D coordinate;
  coordinate.latitude = [self.latitude doubleValue];
  coordinate.longitude = [self.longitude doubleValue];
  
  return coordinate;
}

-(NSString *)title
{
  NSString *title = self.name;
  
  return title;
}

-(MKAnnotationView *)annotationView
{
  MKAnnotationView *view = [[MKAnnotationView alloc] initWithAnnotation:self reuseIdentifier:@"BuildingAnnotation"];
  
  UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 46, 46)];
  view.leftCalloutAccessoryView = imageView;
  view.enabled = true;
  view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  view.canShowCallout = true;
  view.image = [UIImage imageNamed:@"location"];
  
  return view;
}

//-(MKPinAnnotationView *)buildingPin
//{
//  MKPinAnnotationView *buildingPin;
////  buildingPin.pinColor = MKPinAnnotationColorPurple;
//  buildingPin.animatesDrop = true;
//  
//  return buildingPin;
//}
//
//-(void)setBuildingPin:(MKPinAnnotationView *)buildingPin
//{
//  buildingPin.pinColor = MKPinAnnotationColorPurple;
//  buildingPin.animatesDrop = true;
//}

@end
