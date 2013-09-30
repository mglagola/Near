//
//  NearTests.m
//  NearTests
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Venue.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>

@interface NearTests : XCTestCase

@end

@implementation NearTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testIdentifier
{
    NSDictionary *json = @{
                           @"id" : @"4d4b7104d754a06370d81259",
                           @"name": @"Bills Grill",
                           @"canonicalUrl": @"http://markglagola.com/",
                           @"verified": @1,
                           @"location.address": @"915 Bills Road",
                           };
    
    NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
    Venue *venue = [Venue venueWithJSON:json context:context];
    XCTAssertNotNil(venue.identifier, @"Venue: %@, Name: %@",venue, venue.name);
    [MagicalRecord saveUsingCurrentThreadContextWithBlock:nil completion:nil];
    
    NSString *identifier = [json valueForKey:@"id"];
    XCTAssertNotNil(identifier, @"Identifier nil!");
    venue = [Venue venueWithIdentifier:identifier context:context];
    XCTAssertNotNil(venue, @"venue is nil");
    XCTAssertNotNil(venue.identifier, @"%@ identifier is nil", venue);
}

@end
