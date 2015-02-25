//
//  ImageCell.m
//  NowAndThen
//
//  Created by Pho Diep on 2/24/15.
//  Copyright (c) 2015 Pho Diep. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setTranslatesAutoresizingMaskIntoConstraints:false];
        [self addSubview:self.imageView];

        NSDictionary *views = @{@"image":self.imageView};
        
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[image]|" options:0 metrics:nil views:views]];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[image]|" options:0 metrics:nil views:views]];
    }
    
    return self;
}

@end
