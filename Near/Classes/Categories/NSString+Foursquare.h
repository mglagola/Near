//
//  NSString+Foursquare.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Foursquare)

+ (NSString*) foursquareURLStringWithSuffix:(NSString*)suffix params:(NSDictionary*)params;

@end
