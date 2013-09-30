//
//  GBDataFetcher.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation+FoursquareVenues.h"

@import CoreLocation.CLLocation;

@class Venue;

@interface NRDataFetcher : NSObject

@property (nonatomic, readonly) NSArray *venues;
@property (nonatomic, assign) NSInteger currentVenueIndex;
@property (nonatomic, readonly) BOOL isFetching;

@property (nonatomic, copy) void (^venusLoadedHandler)(Venue* venue);

+ (instancetype) shared;

- (void) fetchData:(CLLocation*)location;

- (void) fetchData:(CLLocation*)location success:(void (^) (void))success failure:(FailureBlock)failure;

- (void) fetchData:(CLLocation*)location start:(void (^) (void))start success:(void (^) (void))success failure:(FailureBlock)failure completion:(void (^) (void))completion;

- (Venue*) nextVenue;
- (Venue*) currentVenue;
- (Venue*) previousVenue;

@end
