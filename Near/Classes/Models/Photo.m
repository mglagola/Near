//
//  Photo.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "Photo.h"
#import "Venue.h"

@implementation Photo

NSString * const kPhotoPrimaryKey = @"identifier";

@dynamic identifier;
@dynamic createdAtTimestamp;
@dynamic url;
@dynamic source;
@dynamic venue;

+ (instancetype) photoWithId:(NSString*)identifier {
    return [self objectWithPrimaryKey:kPhotoPrimaryKey primaryValue:identifier context:[NSManagedObjectContext MR_contextForCurrentThread]];
}

+ (instancetype) photoWithJSON:(NSArray*)json venue:(Venue*)venue context:(NSManagedObjectContext*)context{
    NSDictionary *map = @{
                          @"id" : kVenuePrimaryKey,
                          @"createdAt": @"createdAtTimestamp",
                          @"source.name" : @"source",
                          };
    
    Photo *photo = [self objectWithJSON:json primaryKey:kPhotoPrimaryKey map:map context:context];
    photo.venue = venue;
    return photo;
}

+ (instancetype) objectWithJSON:(NSArray*)json primaryKey:(NSString *)primaryKey map:(NSDictionary *)map context:(NSManagedObjectContext *)context{
    Photo *photo = [super objectWithJSON:json primaryKey:primaryKey map:map context:context];
    photo.url = [NSString stringWithFormat:@"%@%dx%d%@", [json valueForKey:@"prefix"], [[json valueForKey:@"width"] integerValue], [[json valueForKey:@"height"] integerValue],[json valueForKey:@"suffix"]];
    return photo;
}

@end
