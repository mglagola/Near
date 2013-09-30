//
//  Category.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface VenueCategory : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * pluralName;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSNumber * primary;
@property (nonatomic, retain) NSNumber * isSubcategory;
@property (nonatomic, retain) NSSet *venues;

+ (instancetype) categoryWithJSON:(id)json;
+ (instancetype) categoryWithJSON:(id)json context:(NSManagedObjectContext*)context;

@end

@interface VenueCategory (CoreDataGeneratedAccessors)

- (void)addVenuesObject:(Venue *)value;
- (void)removeVenuesObject:(Venue *)value;
- (void)addVenues:(NSSet *)values;
- (void)removeVenues:(NSSet *)values;

@end
