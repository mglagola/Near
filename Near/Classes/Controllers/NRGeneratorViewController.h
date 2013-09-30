//
//  NRGeneratorViewController.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRFRCCollectionViewController.h"

@import CoreLocation;
@import MapKit;

@class Venue, NRDataFetcher;

@interface NRGeneratorViewController : NRFRCCollectionViewController <CLLocationManagerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate, UIActionSheetDelegate>

@property (nonatomic, readonly) CLLocationManager *locationManager;
@property (nonatomic) CLLocation *recentLocation;
@property (nonatomic) Venue *venue;

@property (nonatomic, readonly) BOOL isShowingOverlay;

@end
