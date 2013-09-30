//
//  NSString+Foursquare.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NSString+Foursquare.h"
#import "NSDictionary+URLString.h"

@implementation NSString (Foursquare)

+ (NSString*) foursquareURLStringWithSuffix:(NSString*)suffix params:(NSDictionary*)params {
    NSDictionary *defaultParams = @{
                                 @"client_id": @"TAONVXS42GG3RMZMWYXP0USFG5JI1KYNJEZ2T1VHUWEPOCCP",
                                 @"client_secret": @"AWVRUP3FFFS22PBYH2G4YFYJW1VSSUPOKE3CT1PELUJ30HYS",
                                 @"v": kFoursquareApiTimestamp,
                                 };

    NSString *urlString = [NSString stringWithFormat:@"%@%@?%@",kFoursquareApiBaseURL, suffix, [defaultParams stringBySeperatingWithAnd]];
    if (params)
        urlString = [urlString stringByAppendingFormat:@"&%@", [params stringBySeperatingWithAnd]];
    return urlString;
}

@end
