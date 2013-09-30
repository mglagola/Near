//
//  NSUserDefaults+Near.m
//  Near
//
//  Created by Mark Glagola on 6/27/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NSUserDefaults+Near.h"

@implementation NSUserDefaults (Near)

NSString * const kUserDefaultsRangeKey = @"MilesRange";
NSString * const kUserDefaultsOrderedResultsKey = @"OrderedResults";
NSString * const kUserDefaultsVenueCategoryIdKey = @"VenueCategory";

+ (void) setDefaults {
    [self isOrderedResults];
    [self range];
    [self venueCategoryId];
    [[self standardUserDefaults] synchronize];
}

+ (BOOL) synchronize {
    return [[self standardUserDefaults] synchronize];
}

+ (BOOL) isOrderedResults {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsOrderedResultsKey];
    if (!num) {
        [self setOrderedResults:YES];
        num = @YES;
    }
    return num.boolValue;
}

+ (void) setOrderedResults:(BOOL)isOrdered {
    [[NSUserDefaults standardUserDefaults] setObject:@(isOrdered) forKey:kUserDefaultsOrderedResultsKey];
}

+ (float) range {
    NSNumber *num = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsRangeKey];
    if (!num) {
        [self setRange:1.0f];
        num = @1.0f;
    }
    return num.floatValue;
}

+ (void) setRange:(float)range {
    [[NSUserDefaults standardUserDefaults] setObject:@(range) forKey:kUserDefaultsRangeKey];
}

+ (NSString*) venueCategoryId {
    NSString *venueId = [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsVenueCategoryIdKey];
    if (!venueId) {
        [self setVenueCategoryId:kFoursquareFoodCategoryId];
        venueId = kFoursquareFoodCategoryId;
    }
    return venueId;
}

+ (void) setVenueCategoryId:(NSString*)categoryId {
    [[NSUserDefaults standardUserDefaults] setObject:categoryId forKey:kUserDefaultsVenueCategoryIdKey];
}


@end
