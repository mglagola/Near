//
//  Category.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "VenueCategory.h"
#import "Venue.h"
#import "NSManagedObject+Map.h"

@implementation VenueCategory

@dynamic identifier;
@dynamic name;
@dynamic pluralName;
@dynamic shortName;
@dynamic iconURL;
@dynamic venues;
@dynamic isSubcategory;
@dynamic primary;

+ (instancetype) categoryWithJSON:(id)json {
    return [self categoryWithJSON:json context:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (instancetype) categoryWithJSON:(id)json context:(NSManagedObjectContext*)context {
    NSDictionary *map = @{
                          @"id" : @"identifier",
                          @"name": @"name",
                          @"pluralName": @"pluralName",
                          @"primary": @"primary",
                          @"shortName": @"shortName",
                          };
    
    VenueCategory *category = [self objectWithJSON:json primaryKey:@"identifier" map:map context:context];
    NSString *prefix = [json valueForKeyPath:@"icon.prefix"];
    category.iconURL = [NSString stringWithFormat:@"%@%@", [prefix substringToIndex:prefix.length-1], [json valueForKeyPath:@"icon.suffix"]];
    
    return category;
}

@end
