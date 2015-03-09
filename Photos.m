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
      
      NSString *thumbnailUrl = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_s.jpg",item[@"farm"], item[@"server"], item[@"id"], item[@"secret"]];
      NSString *fullsizeUrl  = [NSString stringWithFormat:@"https://farm%@.staticflickr.com/%@/%@_%@_z.jpg",item[@"farm"], item[@"server"], item[@"id"], item[@"secret"]];
      newPhoto.thumbImageURL = thumbnailUrl;
      newPhoto.fullSizeImageURL = fullsizeUrl;
      
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


-(UIImage *)thumbImage
{
  if (!_thumbImage)
  {
    _thumbImage = [[UIImage alloc] init];
  }
  return _thumbImage;
}


@end
