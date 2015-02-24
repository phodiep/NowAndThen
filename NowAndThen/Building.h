//
//  Building.h
//  NowAndThen
//
//  Created by Gru on 02/22/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Building : NSObject

@property (strong, nonatomic) NSString* latitude;
@property (strong, nonatomic) NSString* longitude;
@property (strong, nonatomic) NSString* buildingName;

//@property (strong, nonatomic) NSDictionary *aBuilding;
//@property (strong, nonatomic) Building *building;

+(NSArray*)fetchBuildingDataFromFile;
-(void) print;

@end