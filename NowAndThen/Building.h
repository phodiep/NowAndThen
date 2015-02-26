//
//  Building.h
//  NowAndThen
//
//  Created by Gru on 02/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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

@property (strong, nonatomic) NSString *googleURL;
@property (strong, nonatomic) NSString *wikipediaURL;
@property (strong, nonatomic) NSString *yahooURL;

@property (strong, nonatomic) NSString *oldImageURL;
@property (strong, nonatomic) NSString *modernImageURL;

-(instancetype)initWithJson:(NSDictionary*) jsonDictionary;
-(instancetype)initFakeBuilding;
+(NSArray*)fetchBuildingsFromJsonData:(NSData *)data;

+(NSArray*)fetchBuildingDataFromFile;
-(void) print;

@end
