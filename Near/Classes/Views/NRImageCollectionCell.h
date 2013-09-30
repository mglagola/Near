//
//  NRCollectionCell.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDWebImage-ProgressView/UIImageView+ProgressView.h>

@class MKMapView, CLLocation;

@interface NRImageCollectionCell : UICollectionViewCell

@property (nonatomic, readonly) UIImageView *imageView;
@property (nonatomic) UIColor *color;
@property (nonatomic, readonly) MKMapView *mapView;

- (void) setRegion:(CLLocation*)centerLoc toDestination:(CLLocation*)toDest title:(NSString*)title;
- (void) setImageWithURL:(NSURL*)url;

@end
