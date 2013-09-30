//
//  Venue.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Photo, CLLocation, Menu, VenueCategory;

@interface Venue : NSManagedObject

extern NSString * const kVenuePrimaryKey;

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * canonicalUrl;
@property (nonatomic, retain) NSString * cc;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * crossStreet;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * postalCode;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * verified;
@property (nonatomic, retain) NSSet *photos;
@property (nonatomic, retain) NSNumber * rating;
@property (nonatomic, retain) NSString * phoneNumber;
@property (nonatomic, retain) NSNumber * areDetailsSynced;

@property (nonatomic, retain) Menu *menu;
@property (nonatomic, retain) NSSet *categories;

//not stored in core data
@property (nonatomic, readonly) CLLocation *location;
@property (nonatomic, readonly) NSNumber* medianPrice;
@property (nonatomic, readonly) NSNumber* averagePrice;
@property (nonatomic, readonly) NSURL *phoneNumberURL;

+ (instancetype) venueWithIdentifier:(NSString *)identifier context:(NSManagedObjectContext*)context;
+ (instancetype) venueWithJSON:(NSArray*)json context:(NSManagedObjectContext*)context;

- (int) roundedRating;
- (VenueCategory*) primaryCategory;
- (void)setCategories:(NSSet*)values; //will delete and add new category values
- (NSString*) mapsAddress;

@end

@interface Venue (CoreDataGeneratedAccessors)

- (void)addPhotosObject:(Photo *)value;
- (void)removePhotosObject:(Photo *)value;
- (void)addPhotos:(NSSet *)values;
- (void)removePhotos:(NSSet *)values;

- (void)addCategoriesObject:(VenueCategory *)value;
- (void)removeCategoriesObject:(VenueCategory *)value;
- (void)addCategories:(NSSet *)values;
- (void)removeCategories:(NSSet *)values;

@end
