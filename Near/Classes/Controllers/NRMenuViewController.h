//
//  NRMenuViewController.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRFRCTableViewController.h"

@class Venue;

@interface NRMenuViewController : NRFRCTableViewController <UITableViewDelegate>

- (id) initWithVenue:(Venue*)v;

@end
