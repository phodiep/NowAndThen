//
//  Building.m
//  NowAndThen
//
//  Created by Gru on 02/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//:

#import <Foundation/Foundation.h>
#import "Building.h"

@interface Building ()

@end

@implementation Building

-(instancetype)initFakeBuilding {
    self = [super init];
    self.longitude = @"-73.88";
    self.latitude = @"40.78";
    
    self.name = @"Fake Building";
    self.address = @"2001 W. Garfield Street";
    self.city = @"Seattle";
    self.state = @"WA";
    self.zipcode = @"98119-3115";
    self.buildDate = @"1944";
    self.buildCompletion = @"1944";
    self.crossStreetEastWest = @"W. Garfield Street";
    self.crossStreetNorthSouth = @"15th Ave W";
    self.infosites = @[@"http://www.seattle.gov/neighborhoods/preservation/documents/DesRptAdmiralsHouse.pdf"];
    self.imageUrls = @[@"http://seamlessmoves.com/blog/wp-content/uploads/2012/12/Admirals-House.jpg"];
    
    return self;
    
}

-(instancetype)initWithJson:(NSDictionary*) jsonDictionary {
    
    self = [super init];
    
    if (self) {
        NSDictionary *location = jsonDictionary[@"loc"];
        NSArray *coordinates = location[@"coordinates"];
        self.longitude = coordinates[0];
        self.latitude = coordinates[1];

        self.name = jsonDictionary[@"buildingName"];
        self.address = jsonDictionary[@"buildingAddress"];
        self.city = jsonDictionary[@"city"];
        self.state = jsonDictionary[@"state"];
        self.zipcode = jsonDictionary[@"zipcode"];
        self.buildDate = jsonDictionary[@"buildDate"];
        self.buildCompletion = jsonDictionary[@"buildCompletion"];
        self.crossStreetEastWest = jsonDictionary[@"crossStreetEastWest"];
        self.crossStreetNorthSouth = jsonDictionary[@"crossStreetNorthSouth"];
        self.infosites = jsonDictionary[@"infosites"];
        self.imageUrls = jsonDictionary[@"images"];
    }
    return self;
}

+ (NSArray*)fetchBuildingsFromJsonData:(NSArray*) data {
    NSMutableArray *buildings = [[NSMutableArray alloc] init];
    
    for ( NSDictionary *item in data ) {
        Building *building = [[Building alloc] initWithJson:item];
        [buildings addObject:building];
    }
    
    return buildings;
}


-(id) init {
    self = [super init];
    if ( self ) {
        self.name = @"Test: Smith Tower";
        NSLog( @"%@", self.name);
    }
    return self;
}

-(id) initWithInfo: (NSDictionary *) info {
    //NSString *jsonFile = @"oneBuilding.json";

    self = [super init];
    if ( self ) {
        self.name = @"Test: Smith Tower";
        NSLog( @"%@", self.name);
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

//  NSInteger numberOfBuildings = buildingsDictionary.count;

    NSArray             *arrayOfBuildings   = buildingsDictionary[@"buildings"];
//  NSInteger numberOfKeys = arrayOfBuildings.count;
    NSLog( @"%@\n\n", arrayOfBuildings[0] );

    return arrayOfBuildings;
}

@end