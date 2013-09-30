//
//  Photo.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue;

@interface Photo : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * createdAtTimestamp;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) Venue *venue;

+ (instancetype) photoWithId:(NSString*)identifier;

+ (instancetype) photoWithJSON:(NSArray*)json venue:(Venue*)venue context:(NSManagedObjectContext*)context  ;

@end
