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
  imageView.image = self.thumbImage;
  view.leftCalloutAccessoryView = imageView;  
  view.image = self.thumbImage;
  view.enabled = true;
  view.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
  view.canShowCallout = true;
  [view addSubview:imageView];
  view.frame = CGRectMake(self.coordinate.latitude, self.coordinate.longitude, 50, 50);
  view.layer.cornerRadius = 10.0;
  imageView.layer.masksToBounds = true;
  imageView.image = self.thumbImage;
  [[NetworkController sharedService] fetchBuildingImage:self.fullSizeImageURL withCompletionHandler:^(UIImage *image) {
    self.thumbImage = image;
    imageView.image = self.thumbImage;
  }];
  return view;
}


@end
