//
//  AFJSONRequestOperation+FoursquareVenues.m
//  Near
//
//  Created by Mark Glagola on 6/21/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "AFJSONRequestOperation+FoursquareVenues.h"
#import "NSString+Foursquare.h"
#import "Venue.h"

@import CoreLocation.CLLocation;

@implementation AFJSONRequestOperation (Foursquare)

+ (instancetype) foursquareJSONRequestOperationWithSuffix:(NSString*)suffix parameters:(NSDictionary *)params  success:(void (^)(NSURLRequest *, NSHTTPURLResponse *, id))success failure:(void (^)(NSURLRequest *, NSHTTPURLResponse *, NSError *, id))failure
{
    NSString *urlString = [NSString foursquareURLStringWithSuffix:suffix params:params];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    return [self JSONRequestOperationWithRequest:request success:success failure:failure];
}

+ (void) startFoursquareVenueSearchJSONRequestOperationWithLocation:(CLLocation*) location
                                                  radius:(int)radius
                                        success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                        failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    if (!location)
        return;
    
    NSDictionary *parameters = @{@"ll": [NSString stringWithFormat:@"%f,%f", location.coordinate.latitude, location.coordinate.longitude],
                                 @"radius" : @(radius),
                                 @"categoryId" : [NSUserDefaults venueCategoryId],
                                 };
    
    AFJSONRequestOperation *operation = [self foursquareJSONRequestOperationWithSuffix:[kFoursquareApiVenueSuffix stringByAppendingString:kFoursquareApiVenueSearchSuffix] parameters:parameters success:success failure:failure];
    [operation start];
}

+ (instancetype) startFoursquareExtraDetailVenueJSONRequestOperationWithLocation:(Venue*) venue
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    if (!venue || !venue.identifier)
        return nil;

    NSString *suffix = [kFoursquareApiVenueSuffix stringByAppendingString:venue.identifier];
    AFJSONRequestOperation *operation = [self foursquareJSONRequestOperationWithSuffix:suffix parameters:nil success:success failure:failure];
    [operation start];
    return operation;
}

+ (instancetype) startFoursquareVenueMenuJSONRequestOperationForVenue:(Venue*)venue
                                                      success:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                      failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure
{
    if (!venue)
        return nil;
    
    NSString *suffix = [NSString stringWithFormat:@"%@%@/%@",kFoursquareApiVenueSuffix, venue.identifier, kFoursquareApiVenueMenuSuffix];
    AFJSONRequestOperation *operation = [self foursquareJSONRequestOperationWithSuffix:suffix parameters:nil success:success failure:failure];
    [operation start];
    return operation;
}


+ (void) startFoursquareVenueCategoryJSONRequestOperationWithSuccess:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, id JSON))success
                                                             failure:(void (^)(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON))failure {
    NSString *suffix = @"venues/categories";
    AFJSONRequestOperation *operation = [self foursquareJSONRequestOperationWithSuffix:suffix parameters:nil success:success failure:failure];
    [operation start];
}

//

@end
