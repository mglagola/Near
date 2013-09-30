//
//  MenuItem.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "MenuItem.h"
#import "Menu.h"
#import "NSManagedObject+Map.h"
#import "MenuSection.h"

@implementation MenuItem

@dynamic name;
@dynamic identifier;
@dynamic details;
@dynamic price;
@dynamic menu;
@dynamic menuSection;

+ (instancetype) menuItemWithJSON:(id)json menuSection:(MenuSection*)menuSection menu:(Menu*)menu context:(NSManagedObjectContext*)context{
    
    NSDictionary *map = @{
                          @"name" : @"name",
                          @"description" : @"details",
                          @"entryId" : @"identifier",
                          };
    MenuItem *menuItem = [self objectWithJSON:json primaryKey:@"identifier" map:map context:context];
    menuItem.price = @([[json valueForKey:@"price"] floatValue]);
    menuItem.menu = menu;
    menuItem.menuSection = menuSection;
    
    return menuItem;
}

@end
