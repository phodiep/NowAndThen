//
//  Photos.h
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface Photos : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *tag;

@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;


-(instancetype)initWithJSON:(NSDictionary *)JSONdata;

+(NSArray *)buildObjectsFromData:(NSData *)data andTag:(NSString *)tag;

//-(NSArray *)setProperCoordinatesWithJSONdata:(NSDictionary *)jsonData;

@end
