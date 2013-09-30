//
//  NRMapAnnotiation.h
//  Near
//
//  Created by Mark Glagola on 6/30/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@import MapKit.MKAnnotation;

@interface NRMapAnnotiation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id) initWithTitle:(NSString*)title coordinate:(CLLocationCoordinate2D)coordinate;
- (id) initWithTitle:(NSString*)title subtitle:(NSString*)subtitle coordinate:(CLLocationCoordinate2D)coordinate;

@end
