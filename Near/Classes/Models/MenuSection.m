//
//  MenuSection.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "MenuSection.h"
#import "Menu.h"
#import "MenuItem.h"
#import "NSManagedObject+Map.h"

@implementation MenuSection

@dynamic identifier;
@dynamic name;
@dynamic menu;
@dynamic menuItems;

+ (instancetype) menuSectionWithJSON:(id)json menu:(Menu*)menu context:(NSManagedObjectContext*)context{
    NSDictionary *map = @{
                          @"name":@"name",
                          @"sectionId":@"identifier",
                          };
    MenuSection *section = [self objectWithJSON:json primaryKey:@"identifier" map:map context:context];
    section.menu = menu;
    
    [[json valueForKeyPath:@"entries.items"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [MenuItem menuItemWithJSON:obj menuSection:section menu:menu context:context];
    }];
    
    return section;
}

@end
