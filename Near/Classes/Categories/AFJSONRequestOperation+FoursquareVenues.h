//
//  AFJSONRequestOperation+FoursquareVenues.h
//  Near
//
//  Created by Mark Glagola on 6/21/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "AFJSONRequestOperation.h"

@class CLLocation, Venue;

typedef void (^FailureBlock)(NSURLRequest *request , NSHTTPURLResponse *response , NSError *error , id JSON);

@interface AFJSONRequestOperation (FoursquareVenues)

+ (instancetype) foursquareJSONRequestOperationWithSuffix:(NSString*)suffix parameters:(NSDictionary *)params  success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure;

+ (void) startFoursquareVenueSearchJSONRequestOperationWithLocation:(CLLocation*) location
                                                  radius:(int)radius
                                                 success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                 failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

+ (instancetype) startFoursquareExtraDetailVenueJSONRequestOperationWithLocation:(Venue*) venue
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

+ (instancetype) startFoursquareVenueMenuJSONRequestOperationForVenue:(Venue*)venue
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

+ (void) startFoursquareVenueCategoryJSONRequestOperationWithSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure;

@end
