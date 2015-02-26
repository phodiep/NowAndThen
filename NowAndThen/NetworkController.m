//
//  NetworkController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "NetworkController.h"

@implementation NetworkController

+ (id)sharedService
{
  static NetworkController *netController;
  static dispatch_once_t dispatchToken;
  dispatch_once(&dispatchToken, ^{
    netController = [[NetworkController alloc] init];
  });
  return netController;
}


#pragma fetchBuildingsForRect
- (void)fetchBuildingsForRect:(NSArray *)rect
           withBuildingLimit:(NSInteger)limit
                    andBlock:(void (^)(NSArray *buildingsFound))completionHandler
{
  
  NSString *urlString = @"http://then-and-now.herokuapp.com/api/v1/building?gettype=invicinityrectangle&radius=.025&";

  NSString *long1 = [NSString stringWithFormat:@"long1=%@", rect[0]];
  NSString *lat1  = [NSString stringWithFormat:@"&lat1=%@", rect[1]];
  NSString *long2 = [NSString stringWithFormat:@"&long2=%@", rect[2]];
  NSString *lat2  = [NSString stringWithFormat:@"&lat2=%@", rect[3]];

  urlString = [urlString stringByAppendingString:long1];
  urlString = [urlString stringByAppendingString:lat1];
  urlString = [urlString stringByAppendingString:long2];
  urlString = [urlString stringByAppendingString:lat2];
  
  NSLog(@"%@",urlString);
  
  NSURL *url = [NSURL URLWithString:urlString];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error)
    {
      NSLog(@"%@",error);
      completionHandler(nil);
    } else {
      NSHTTPURLResponse *taskResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = taskResponse.statusCode;
      
      switch (statusCode)
      {
        case 200 ... 299:
        {
          NSLog(@"%ld",(long)statusCode);
          NSArray *results = [Building fetchBuildingsFromJsonData:data];

          dispatch_async(dispatch_get_main_queue(), ^{
            if (results)
            {
              completionHandler(results);
            } else {
              completionHandler(nil);
            }
          });
          break;
        }
        case 300 ... 599:
        {
          NSLog(@"%ld",(long)statusCode);
          break;
        }
        default:
        {
          NSLog(@"default case reached");
          break;
        }
      }
    }
  }];
  [dataTask resume];
}

#pragma fetchBuildingImage
-(void)fetchBuildingImage:(NSString *)imageURL withCompletionHandler:(void (^)(UIImage *))completionHandler
{
  NSLog(@"url of image: %@",imageURL);

  dispatch_queue_t imageQueue = dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0);
  dispatch_async(imageQueue, ^{
    NSURL *url = [NSURL URLWithString:imageURL];
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imageData];
    
    dispatch_async(dispatch_get_main_queue(), ^{
      completionHandler(image);
    });
  });
}


@end
