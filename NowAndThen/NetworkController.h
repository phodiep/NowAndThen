//
//  NetworkController.h
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Building.h"

@interface NetworkController : NSObject

+ (id)sharedService;

-(void)fetchBuildingsForRect:(NSArray *)rect
           withBuildingLimit:(NSInteger)limit
                    andBlock:(void (^)(NSArray *buildingsFound))completionHandler;

-(void)fetchBuildingImage:(NSString *)imageURL withCompletionHandler:(void (^)(UIImage *image))completionHandler;
-(void)fetchBuildingBySearchTerms:(NSString*)searchTerms withCompletionHandler:(void (^)(NSArray* results))completionHandler;

@end
