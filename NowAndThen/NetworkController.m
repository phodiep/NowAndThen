//
//  NetworkController.m
//  NowAndThen
//
//  Created by Pho Diep on 2/21/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "NetworkController.h"
#import "Photos+Annotation.h"


@implementation NetworkController
// flickr api key df08b7ebda37296e4e09406516dedec3

//flickr client sercret c5e6171a087297c2
+ (id)sharedService
{
  static NetworkController *netController;
  static dispatch_once_t dispatchToken;
  dispatch_once(&dispatchToken, ^{
    netController = [[NetworkController alloc] init];
  });
  return netController;
}


#pragma mark - fetchBuildingsForRect
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
  
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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


-(void)fetchFlickrImagesForBuilding:(NSString *)building
                    withBoundingBox:(NSArray *)box
               andCompletionHandler:(void (^)(NSArray *))completionHandler
{
  NSString *key = @"df08b7ebda37296e4e09406516dedec3";
 // NSString *clientSecret = @"c5e6171a087297c2";
  NSString *numberOfPhotosFetched = @"15";
  
  NSString *compressedBuildingString = [building stringByReplacingOccurrencesOfString:@" "
                                                                           withString:@""];
  
  NSLog(@"%@",compressedBuildingString);
  
  NSString *fetchURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=%@&text=%@&bbox=%@,%@,%@,%@,&content_type=1&per_page=%@&format=json&nojsoncallback=1",key, compressedBuildingString, box[0], box[1], box[2], box[3], numberOfPhotosFetched];
  
  NSURL *url = [NSURL URLWithString:fetchURL];
  
  NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSession *session = [NSURLSession sharedSession];
  
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request
                                          completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error)
    {
      NSLog(@"error in fetchFlickr: %@",error);
    } else {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpResponse.statusCode;
      
      NSArray *photoAlbum;
      
      switch (statusCode)
      {
        case 200 ... 299:
        {
         // NSLog(@"%ld", (long)statusCode);
          
          photoAlbum = [Photos buildObjectsFromData:data andTag:building];
          
          for (int i = 0; i < photoAlbum.count; i++)
          {
            Photos *photo = (Photos *)photoAlbum[i];
            [self fetchFlickrImageLocation:photo.photo_id withCompletionHandler:^(NSArray *coordinates) {
              photo.latitude = coordinates[0];
              photo.longitude = coordinates[1];
            }];
          }
          dispatch_async(dispatch_get_main_queue(), ^{
            if (photoAlbum)
            {
              completionHandler(photoAlbum);
            } else {
              NSLog(@"photoAlbum returns: %@", photoAlbum);
              completionHandler(photoAlbum);
            }
          });
          break;
        }
        case 300 ... 599:
        {
          NSLog(@"%ld", (long)statusCode);
          break;
        }
        default:
        {
          NSLog(@"%ld", (long)statusCode);
        }
      }
    }
  }];
  [dataTask resume];
}

#pragma fetchBuildingImage
-(void)fetchBuildingImage:(NSString *)imageURL withCompletionHandler:(void (^)(UIImage *))completionHandler
{
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


-(void)fetchFlickrImageLocation:(NSString *)photoID withCompletionHandler:(void (^)(NSArray *coordinates))completionHandler
{
  NSString *fetchURL = [NSString stringWithFormat:@"https://api.flickr.com/services/rest/?method=flickr.photos.geo.getLocation&api_key=df08b7ebda37296e4e09406516dedec3&photo_id=%@&format=json&nojsoncallback=1", photoID];
  NSURL *url = [NSURL URLWithString:fetchURL];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
  request.HTTPMethod = @"GET";
  
  NSURLSession *session = [NSURLSession sharedSession];
  NSURLSessionTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
    if (error)
    {
      NSLog(@"error with request: %@",error);
    } else {
      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
      NSInteger statusCode = httpResponse.statusCode;
      
      switch (statusCode)
      {
        case 200 ... 299:
        {
          NSLog(@"%ld",(long)statusCode);
          NSError *error;
          NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
          NSMutableArray *myCoords = [[NSMutableArray alloc] init];
          [myCoords addObject:jsonDictionary[@"photo"][@"location"][@"latitude"]];
          [myCoords addObject:jsonDictionary[@"photo"][@"location"][@"longitude"]];
          
          NSArray *coords = [[NSArray alloc] initWithArray:myCoords];
          
          dispatch_async(dispatch_get_main_queue(), ^{
            if (coords)
            {
              completionHandler(coords);
            } else {
              NSLog(@"photoAlbum returns: %@", coords);
              completionHandler(coords);
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

-(void)fetchBuildings: (void (^)(NSArray* results))completionHandler {
    NSString *endPoint = @"http://then-and-now.herokuapp.com/api/v1/building";
    
    NSURL *url = [NSURL URLWithString:endPoint];
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


-(void)fetchBuildingBySearchTerms:(NSString*)searchTerms withCompletionHandler:(void (^)(NSArray* results))completionHandler {
    if (![searchTerms isEqualToString:@""]) {
        NSString *endPoint = [NSString stringWithFormat:@"http://then-and-now.herokuapp.com/api/v1/building?gettype=searchtags&tag=%@", searchTerms];
        
        NSURL *url = [NSURL URLWithString:endPoint];
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
}


@end
