//
//  Building+Annotation.m
//  NowAndThen
//
//  Created by Josh Kahl on 2/25/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Building+Annotation.h"

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


@end
