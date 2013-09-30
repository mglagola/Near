//
//  Menu.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Venue, MenuItem, MenuSection;

@interface Menu : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSSet *menuItems;
@property (nonatomic, retain) Venue *venue;

+ (instancetype) menuWithJSON:(id)json venue:(Venue*)venue context:(NSManagedObjectContext*)context;

@end

@interface Menu (CoreDataGeneratedAccessors)

- (void)addMenuItemsObject:(MenuItem *)value;
- (void)removeMenuItemsObject:(MenuItem *)value;
- (void)addMenuItems:(NSSet *)values;
- (void)removeMenuItems:(NSSet *)values;

- (void)addMenuSectionsObject:(MenuSection *)value;
- (void)removeMenuSectionsObject:(MenuSection *)value;
- (void)addMenuSections:(NSSet *)values;
- (void)removeMenuSections:(NSSet *)values;


@end
