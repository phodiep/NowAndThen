//
//  NetworkController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+(id)buildingCreator {
    static NetworkController *networkControllerService;
    static dispatch_once_t dispatchToken;
        dispatch_once( &dispatchToken, ^{networkControllerService = [[NetworkController alloc] init];
    });
    return networkControllerService;
}

@end
