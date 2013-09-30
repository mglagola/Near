//
//  MenuItem.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Menu, MenuSection;

@interface MenuItem : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) Menu *menu;
@property (nonatomic, retain) MenuSection *menuSection;

//+ (instancetype) menuItemWithJSON:(id)json menuSection:(MenuSection*)menuSection menu:(Menu*)menu;
+ (instancetype) menuItemWithJSON:(id)json menuSection:(MenuSection*)menuSection menu:(Menu*)menu context:(NSManagedObjectContext*)context;

@end
