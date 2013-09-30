//
//  NSDictionary+URLString.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NSDictionary+URLString.h"

@implementation NSDictionary (URLString)

- (NSString*) stringBySeperatingWithAnd {
    NSMutableString *mutableSelf = [[NSMutableString alloc] init];
    __block int x = 0;
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [mutableSelf appendString:[NSString stringWithFormat:@"%@=%@", key, obj]];
        if (x < self.count-1)
            [mutableSelf appendString:@"&"];
        x++;
    }];
    return mutableSelf;
}

@end
