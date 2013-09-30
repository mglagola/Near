//
//  NSArray+Median.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NSArray+Median.h"

@implementation NSArray (Median)

- (NSArray*) medianObjects {
    if (self.count % 2 == 0) {
        id obj1 = [self objectAtIndex:(int)(self.count / 2)-1];
        id obj2 = [self objectAtIndex:(int)(self.count / 2)];
        return @[obj1, obj2];
    }
    return @[[self objectAtIndex:(int)(self.count / 2)]];
}

@end
