//
//  ImageCell.h
//  NowAndThen
//
//  Created by Pho Diep on 2/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
