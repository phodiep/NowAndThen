//
//  Photos.m
//  NowAndThen
//
//  Created by Josh Kahl on 2/26/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "Photos.h"
#import "NetworkController.h"

@implementation Photos

+(NSArray *)buildObjectsFromData:(NSData *)data andTag:(NSString *)tag
{
  NSError *error;
  NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
  
  if (error)
  {
    NSLog(@"error encountered with json parse: %@", error);
  } else {
    NSDictionary *JSON = jsonDictionary[@"photos"];
    
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    for (NSDictionary *item in JSON[@"photo"])
    {
      Photos *newPhoto = [[Photos alloc] initWithJSON:item];
      newPhoto.tag = tag;
      
      NSString *url = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_s.jpg",item[@"farm"], item[@"server"], item[@"id"], item[@"secret"]];

      newPhoto.imageURL = url;
      [photos addObject:newPhoto];
    }
    NSArray *photoAlbum = [[NSArray alloc] initWithArray:photos];
    return photoAlbum;
  }
  return nil;
}

-(instancetype)initWithJSON:(NSDictionary *)JSONdata
{
  self = [super init];
  if (self)
  {
    self.photo_id = JSONdata[@"id"];
    self.text = JSONdata[@"title"];
  }
  return self;
}

//-(UIImage *)fetchThumbnailforPhoto
//{
//  NSString *farm =
//}

/*
 
 https://%@.staticflickr.com/%@/%@_%@_s.jpg
 
 https://farm1.staticflickr.com/2/1418878_1e92283336_m.jpg

 farm-id: 1
 server-id: 2
 photo-id: 1418878
 secret: 1e92283336
 size: m
 */



//-(NSArray *)setProperCoordinatesWithJSONdata:(NSDictionary *)jsonData
//{
//  
//}

/*******     fetchFlickerPhotos for building

photos =     {
  page = 1;
  pages = 4266;
  perpage = 25;
  photo =         (
                   {
                     farm = 9;
                     id = 16469414830;
                     isfamily = 0;
                     isfriend = 0;
                     ispublic = 1;
                     owner = "23170808@N07";
                     secret = 65317bfb80;
                     server = 8635;
                     title = "Kerry Park sunrise.Seattle,WA";
                   },
 
 ********** fetchFlickerLocations
 photo =     
 {
  id = 16034131513;
  location =         
  {
    accuracy = 16;
    context = 0;
    country =             
    {
      "_content" = "United States";
      "place_id" = "nz.gsghTUb4c2WAecA";
      woeid = 23424977;
    };
  county =            
  {
    "_content" = King;
    "place_id" = e4JdbCFQUL8iSf0rtg;
    woeid = 12590456;
  };
  latitude = "47.629435";
  locality =             
  {
  "_content" = Seattle;
  "place_id" = uiZgkRVTVrMaF2cP;
  woeid = 2490383;
  };
 
 */
@end
