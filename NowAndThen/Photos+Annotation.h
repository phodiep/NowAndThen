//
//  Photos+Annotation.h
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Photos.h"
#import <MapKit/MapKit.h>


@interface Photos (Annotation) <MKAnnotation>

-(MKAnnotationView *)annotationView;

@end
