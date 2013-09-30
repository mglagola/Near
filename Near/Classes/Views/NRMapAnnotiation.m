//
//  NRMapAnnotiation.m
//  Near
//
//  Created by Mark Glagola on 6/30/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRMapAnnotiation.h"

@implementation NRMapAnnotiation

@synthesize subtitle = _subtitle, title = _title;

- (id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate{
    if (self = [super init]) {
        self.title = title;
        self.subtitle = subtitle;
        self.coordinate = coordinate;
    }
    return self;
}

- (id) initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coordinate{
    return [self initWithTitle:title subtitle:nil coordinate:coordinate];
}

@end
