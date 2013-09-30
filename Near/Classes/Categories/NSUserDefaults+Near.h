//
//  NSUserDefaults+Near.h
//  Near
//
//  Created by Mark Glagola on 6/27/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (Near)

extern NSString * const kUserDefaultsRangeKey;
extern NSString * const kUserDefaultsOrderedResultsKey;
extern NSString * const kUserDefaultsVenueCategoryIdKey;

+ (void) setDefaults; //set and save defaults
+ (BOOL) synchronize;

+ (BOOL) isOrderedResults;
+ (void) setOrderedResults:(BOOL)isOrdered;

+ (float) range;
+ (void) setRange:(float)range;

+ (NSString*) venueCategoryId;
+ (void) setVenueCategoryId:(NSString*)categoryId;

@end
