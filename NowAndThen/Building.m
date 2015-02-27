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
    if (self) {
        self.longitude = @"-122.3487383";
        self.latitude = @"47.6206537";
        
        self.name = @"Fake Building";
        self.address = @"2001 W. Garfield Street";
        self.city = @"Seattle";
        self.state = @"WA";
        self.zipcode = @"98119-3115";
        self.buildDate = @"1944";
        self.buildCompletion = @"1944";
        self.crossStreetEastWest = @"W. Garfield Street";
        self.crossStreetNorthSouth = @"15th Ave W";
        
//        self.infosites = @[@"http://www.seattle.gov/neighborhoods/preservation/documents/DesRptAdmiralsHouse.pdf"];
        
        self.googleURL = @"http://www.google.com";
        self.yahooURL = @"http://www.yahoo.com";
        self.wikipediaURL = @"http://en.wikipedia.org/wiki/Main_Page";

        self.modernImageURL = @"http://seamlessmoves.com/blog/wp-content/uploads/2012/12/Admirals-House.jpg";
        self.oldImageURL = @"http://seamlessmoves.com/blog/wp-content/uploads/2012/12/Admirals-House.jpg";
    }
    return self;
}

-(instancetype)initWithJson:(NSDictionary*) jsonDictionary {
    self = [super init];
    if (self) {
        NSDictionary *location = jsonDictionary[@"loc"];
        NSArray *coordinates = location[@"coordinates"];
        NSDictionary *imageURLs = jsonDictionary[@"images"];
        NSDictionary *sites = jsonDictionary[@"infosites"];
        
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
//        self.infosites = jsonDictionary[@"infosites"];
        
        self.googleURL = sites[@"googleURL"];
        self.yahooURL = sites[@"yahooURL"];
        self.wikipediaURL = sites[@"wikipediaURL"];

        self.modernImageURL = imageURLs[@"url2010"];
        if (imageURLs[@"url1900"] == nil) {
            self.oldImageURL = imageURLs[@"url1913"];
        } else {
            self.oldImageURL = imageURLs[@"url1900"];
        }
    }
    return self;
}

+(NSArray*)fetchBuildingsFromJsonData:(NSData *)data {
 
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:0
                                                                   error:&error];
  if (error)
  {
    NSLog(@"%@", error);
  } else {
   
    NSMutableArray *buildings = [[NSMutableArray alloc] init];
    
    for ( NSDictionary *item in jsonDictionary )
    {
      Building *building = [[Building alloc] initWithJson:item];
      [buildings addObject:building];
    }
    NSArray *convertedArray = [[NSArray alloc] initWithArray:buildings];
    
    return convertedArray;
    //return buildings;
  }
  return nil;
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

-(NSMutableArray *)imageCollection {
    if (_imageCollection == nil) {
        _imageCollection = [[NSMutableArray alloc]init];
    }
    return _imageCollection;
}

@end