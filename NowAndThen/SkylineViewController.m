//
//  SkylineViewController.m
//  NowAndThen
//
//  Created by Gru on 02/25/15.
//  Copyright (c) 2015 GruTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SkylineViewController.h"

@interface SkylineViewController ()

@property (strong, nonatomic) NSMutableDictionary *views;
@property (strong, nonatomic) UIView *skylineView;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UILabel *skylineTitle;

@property (strong, nonatomic) NSMutableArray *images;

@property (nonatomic) BOOL firstSkylineCollectionView;

-(void)building164;

@end

@implementation SkylineViewController

- (IBAction)building164 {
    NSLog(@"building164");
}

- (void)loadView {

    NSLog(@"SkylineViewController::loadView");

    // Set up base view, '_skylineView'
    _skylineView = [[UIView alloc] init];
//    _skylineView.bounds = CGRectMake( 0, 0, CGRectGetWidth( [[UIScreen mainScreen] applicationFrame]),
//                                            CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
    _skylineView.backgroundColor = [UIColor grayColor];

    // Set up image view, '_imageView' and attach it to the '_skylineView'
    _imageView = [[UIImageView alloc] init];
    _imageView.bounds = CGRectMake( 0, 0, CGRectGetWidth( [[UIScreen mainScreen] applicationFrame]),
                                   CGRectGetHeight([[UIScreen mainScreen] applicationFrame]));
//    _imageView.bounds = CGRectMake( 0, 0, 600, 600 );

    // Attach the 'skylineImage' to the '_imageView'
    UIImage *skylineImage = [UIImage imageNamed:@"skyline03.jpeg"];
    _imageView.image = skylineImage;
    _imageView.userInteractionEnabled = true;


//    [self setupAutolayoutForSkylineView];

    self.view = self.skylineView ;
}

- (void)cellForItemAtIndexPath {
    NSLog(@"SkylineViewController::cellForItemAtIndexPath");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSLog(@"SkylineViewController::viewDidLoad");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"SkylineViewController::didReceiveMemoryWarning");
}

//-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    ImageCell *cell = (ImageCell*)[self.imageCollectionView dequeueReusableCellWithReuseIdentifier:@"IMAGE_CELL" forIndexPath:indexPath];
//    int index = (int)(indexPath.row % [self.images count]);
//    cell.imageView.image = self.images[index];
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFit;
//    return cell;
//}

@end
