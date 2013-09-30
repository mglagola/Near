//
//  Venue.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "Venue.h"
#import "Photo.h"
#import "NSArray+Median.h"
#import "NSManagedObject+Map.h"
#import "Menu.h"
#import "MenuItem.h"
#import "VenueCategory.h"

@import CoreLocation.CLLocation;

@implementation Venue

NSString * const kVenuePrimaryKey = @"identifier";

@dynamic address;
@dynamic canonicalUrl;
@dynamic cc;
@dynamic city;
@dynamic country;
@dynamic crossStreet;
@dynamic distance;
@dynamic identifier;
@dynamic latitude;
@dynamic longitude;
@dynamic name;
@dynamic postalCode;
@dynamic state;
@dynamic verified;
@dynamic photos;
@dynamic rating;
@dynamic menu;
@dynamic phoneNumber;
@dynamic categories;
@dynamic areDetailsSynced;

@synthesize phoneNumberURL = _phoneNumberURL;
@synthesize location = _location, medianPrice = _medianPrice, averagePrice = _averagePrice;

+ (instancetype) venueWithIdentifier:(NSString *)identifier context:(NSManagedObjectContext*)context{
    return [self objectWithPrimaryKey:kVenuePrimaryKey primaryValue:identifier context:context];
}

+ (instancetype) venueWithJSON:(NSArray*)json context:(NSManagedObjectContext*)context{
    
    NSDictionary *map = @{
                          @"id" : kVenuePrimaryKey,
                          @"name": @"name",
                          @"canonicalUrl": @"canonicalUrl",
                          @"verified": @"verified",
                          @"location.address": @"address",
                          @"location.crossStreet": @"crossStreet",
                          @"location.lat": @"latitude",
                          @"location.lng": @"longitude",
                          @"location.distance": @"distance",
                          @"location.postalCode": @"postalCode",
                          @"location.city": @"city",
                          @"location.state": @"state",
                          @"location.country": @"country",
                          @"location.cc": @"cc",
                          @"rating": @"rating",
                          @"contact.formattedPhone": @"phoneNumber"
                          };
    
    return [self objectWithJSON:json primaryKey:kVenuePrimaryKey map:map context:context];
}

- (CLLocation*) location {
    if (!_location)
        _location = [[CLLocation alloc] initWithLatitude:self.latitude.doubleValue longitude:self.longitude.doubleValue];
    return _location;
}

- (NSNumber*) medianPrice {
    if (!_medianPrice) {
        NSArray *medianObjects = [[[[self.menu.menuItems allObjects] valueForKey:@"price"] sortedArrayUsingSelector:@selector(compare:)] medianObjects];
        NSLog(@"%@",self.menu);
        if (medianObjects.count == 2) {
            float v1 = [[medianObjects objectAtIndex:0] floatValue];
            float v2 = [[medianObjects objectAtIndex:1] floatValue];
            _medianPrice = @((v1 + v2)*.5f);
        } else {
            _medianPrice = [medianObjects lastObject];
        }
    }
    return _medianPrice;
}

- (NSNumber*) averagePrice {
    if (!_averagePrice) {
        __block float sum = 0;
        __block int i = 0;
        [self.menu.menuItems enumerateObjectsUsingBlock:^(MenuItem *menuItem, BOOL *stop) {
            if (menuItem.price.floatValue > 0) {
                i++;
                sum += menuItem.price.floatValue;
            }
        }];
        _averagePrice = (sum == 0 || i == 0) ? @0 : @(sum / i);
    }
    return _averagePrice;
}

- (int) roundedRating {
    return roundf(self.rating.floatValue*.5f);
}

- (VenueCategory*) primaryCategory {
    return [[[self.categories filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"primary == YES"]] allObjects] lastObject];
}

- (NSURL*) phoneNumberURL {
    if (!_phoneNumberURL) {
        NSString *urlString = [[NSString stringWithFormat:@"telprompt://%@",self.phoneNumber] stringByReplacingOccurrencesOfString:@" " withString:@""];
        _phoneNumberURL = [NSURL URLWithString:urlString];
    }
    return _phoneNumberURL;
}

- (NSString*) mapsAddress {
    return [self.address stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

- (void)setCategories:(NSSet*)values {
    //Remove categories from venue
    NSArray *categories = [VenueCategory MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"%@ IN venues", self]];
    [categories enumerateObjectsUsingBlock:^(VenueCategory *category, NSUInteger idx, BOOL *stop) {
        [category removeVenuesObject:self];
    }];
    [self addCategories:values];
}

@end
