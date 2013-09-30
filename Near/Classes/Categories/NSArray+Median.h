//
//  NSArray+Median.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Median)

//if count is EVEN - two objects will be returned
//if count is ODD - one object will be returned
- (NSArray*) medianObjects;

@end
