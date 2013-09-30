//
//  NRCollectionCell.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRImageCollectionCell.h"
#import "NRMapAnnotiation.h"
#import "MKMapView+LegalLabel.h"

static int const Z_POS_TOP = 5;
static int const Z_POS_BOTTOM = 4;

@import MapKit.MKMapView;

@implementation NRImageCollectionCell

@synthesize imageView = _imageView;
@synthesize mapView = _mapView;
@synthesize color = _color;

- (MKMapView*) mapView {
    if (!_mapView) {
        _mapView = [[MKMapView alloc] init];
        _mapView.frame = self.contentView.frame;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        _mapView.scrollEnabled = NO;
        [self.contentView addSubview:_mapView];
    }
    return _mapView;
}

- (UIImageView*) imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.contentView.frame];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (void) setDefaults {
    self.contentView.layer.shadowOffset = CGSizeMake(1, 1);
    self.contentView.layer.shadowRadius = 2;
    self.backgroundColor = [UIColor clearColor];
    self.color = nil;
}

- (id) init {
    return [self initWithFrame:CGRectZero];
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaults];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaults];
    }
    return self;
}

- (void) setRegion:(CLLocation*)centerLoc toDestination:(CLLocation*)toDest title:(NSString*)title{
    if (!centerLoc)
        return;
    
    CLLocationDistance dist = [centerLoc distanceFromLocation:toDest] / 100000.0f;
    
    self.mapView.region = MKCoordinateRegionMake(centerLoc.coordinate, MKCoordinateSpanMake(dist, dist*3));
    [self.mapView removeAnnotations:[self.mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF != %@", self.mapView.userLocation]]];
    
    NRMapAnnotiation *annotation = [[NRMapAnnotiation alloc] initWithTitle:title coordinate:toDest.coordinate];
    [self.mapView addAnnotation:annotation];
    [self.mapView moveLegalLabelTo:CGPointMake(5, 5)];
    [self shouldShowImageView:NO];
}

- (void) setColor:(UIColor *)color {
    _color = color;
    if (color) {
        self.backgroundColor = color;
        [self hideAllOverlayViews];
    } else {
        self.backgroundColor = [UIColor blackColor];
    }
}

- (void) setImageWithURL:(NSURL*)url {
    [self.imageView setImageWithURL:url usingProgressView:nil];
    [self shouldShowImageView:YES];
}

- (void) shouldShowImageView:(BOOL)shouldShow {
    if (shouldShow)  {
        self.mapView.layer.zPosition = Z_POS_BOTTOM;
        self.imageView.layer.zPosition = Z_POS_TOP;
    } else {
        self.mapView.layer.zPosition = Z_POS_TOP;
        self.imageView.layer.zPosition = Z_POS_BOTTOM;
    }
    self.imageView.hidden = !shouldShow;
    self.mapView.hidden = shouldShow;
}

- (void) hideAllOverlayViews {
    self.imageView.hidden = YES;
    self.mapView.hidden = YES;
}

@end
