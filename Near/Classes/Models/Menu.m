//
//  Menu.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "Menu.h"
#import "Venue.h"
#import "MenuSection.h"
#import "NSManagedObject+Map.h"

@implementation Menu

@dynamic name;
@dynamic details;
@dynamic identifier;
@dynamic menuItems;
@dynamic venue;

+ (instancetype) menuWithJSON:(id)json venue:(Venue*)venue context:(NSManagedObjectContext*)context{
    NSDictionary *map = @{
                          @"name":@"name",
                          @"description":@"details",
                          @"menuId":@"identifier",
                          };
    Menu *menu = [self objectWithJSON:json primaryKey:@"identifier" map:map context:context];
    menu.venue = venue;
    
    [[json valueForKeyPath:@"entries.items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [MenuSection menuSectionWithJSON:obj menu:menu context:context];
    }];
    
    return menu;
}

@end
