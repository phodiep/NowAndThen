//
//  Photos.h
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* 
 farm-id: 1
 server-id: 2
 photo-id: 1418878
 secret: 1e92283336
 size: m
 */
@interface Photos : NSObject

@property (strong, nonatomic) NSString *photo_id;
@property (strong, nonatomic) NSString *text;

@property (strong, nonatomic) NSString *tag;

@property (strong, nonatomic) NSString *thumbImageURL;
@property (strong, nonatomic) UIImageView *thumbImageView;

@property (strong, nonatomic) NSString *fullSizeImageURL;

@property (strong, nonatomic) NSString *latitude;
@property (strong, nonatomic) NSString *longitude;


-(instancetype)initWithJSON:(NSDictionary *)JSONdata;

+(NSArray *)buildObjectsFromData:(NSData *)data andTag:(NSString *)tag;

@end
