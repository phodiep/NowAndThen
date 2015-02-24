//
//  Building.m
//  NowAndThen
//
//  Created by Gru on 02/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//:

#import <Foundation/Foundation.h>
#import "Building.h"


@implementation Building {

}

-(id) init {
    self = [super init];
    if ( self ) {
        self.buildingName = @"Test: Smith Tower";
        NSLog( @"%@", self.buildingName);
    }
    return self;
}

-(id) initWithInfo: (NSDictionary *) info {
    //NSString *jsonFile = @"oneBuilding.json";

    self = [super init];
    if ( self ) {
        self.buildingName = @"Test: Smith Tower";
        NSLog( @"%@", self.buildingName);
    }
    return self;
}

-(void) print {
    NSLog(@"Building Information");
}

+ (NSArray*)fetchBuildingDataFromFile {

    NSBundle *thisBundle = [NSBundle bundleForClass:[self class]];
    //    NSString *buildingsDictionaryPath = [thisBundle pathForResource:@"simpleBuilding" ofType:@"json"];
    NSString *buildingsDictionaryPath = [thisBundle pathForResource:@"simple01" ofType:@"json"];

    NSData  *fileData = [[NSData alloc] initWithContentsOfFile: buildingsDictionaryPath];
    NSError *error;
    NSMutableDictionary *buildingsDictionary= [NSJSONSerialization
                                               JSONObjectWithData:fileData
                                               options:NSJSONReadingMutableContainers
                                               error:&error];
    if ( error ) {
        NSLog( @"Error occured while tring to get the building data" );
        NSLog( @"%@", error );
    } else {
        NSLog( @"%@\n", buildingsDictionary );
        NSLog( @"%@\n", buildingsDictionary.allKeys);
        NSLog( @"%@\n", buildingsDictionary[@"buildings"]);
    }

    NSInteger numberOfBuildings = buildingsDictionary.count;

    NSArray             *arrayOfBuildings   = buildingsDictionary[@"buildings"];
    NSInteger numberOfKeys = arrayOfBuildings.count;
    NSLog( @"%@\n\n", arrayOfBuildings[0] );

    return arrayOfBuildings;
}

@end