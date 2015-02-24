//
//  Building.h
//  NowAndThen
//
//  Created by Gru on 02/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Building : NSObject

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *address;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) NSString *zipcode;
@property (strong, nonatomic) NSString *buildDate;
@property (strong, nonatomic) NSString *buildCompletion;
@property (strong, nonatomic) NSString *crossStreetEastWest;
@property (strong, nonatomic) NSString *crossStreetNorthSouth;
@property (strong, nonatomic) NSArray *infosites;
@property (strong, nonatomic) NSArray *imageUrls;

-(instancetype)initWithJson:(NSDictionary*) jsonDictionary;
-(instancetype)initFakeBuilding;

+(NSArray*)fetchBuildingDataFromFile;
-(void) print;

@end


/*
  {"loc": { "type": "Point", coordinates: [ -73.88, 40.78 ] },
 "buildingName": "Replace Test - changed lat and long",  
 "buildingAddress": "2001 W. Garfield Street",  
 "city": "Seattle",  
 "state": "WA",  
 "zipcode": "98119-3115",  
 "buildDate": "1944",  
 "buildCompletion": "1944",  
 "crossStreetEastWest": "W. Garfield Street",  
 "crossStreetNorthSouth": "15th Ave W",  
 "infosites": {
    "wikipediaURL": "",    "yahooURL": "",    "googleURL": "http://www.seattle.gov/neighborhoods/preservation/documents/DesRptAdmiralsHouse.pdf"
 },  "images": {
 "url1900": "",    "url2010": "http://seamlessmoves.com/blog/wp-content/uploads/2012/12/Admirals-House.jpg"
 
 "tags": ["Washington Mutual","Tower", "tall buildings"],  "crtTimestamp": "2-23-2015 16:00",  "crtUser": "Initial_Load",  "updtTimestamp": "2-23-2015 16:00",  "updtUser": "Initial_Load"}'
*/
