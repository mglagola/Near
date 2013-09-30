//
//  MenuSection.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu, MenuItem;

@interface MenuSection : NSManagedObject

@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Menu *menu;
@property (nonatomic, retain) NSSet *menuItems;

+ (instancetype) menuSectionWithJSON:(id)json menu:(Menu*)menu context:(NSManagedObjectContext*)context;

@end

@interface MenuSection (CoreDataGeneratedAccessors)

- (void)addMenuItemsObject:(MenuItem *)value;
- (void)removeMenuItemsObject:(MenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

@end
