//
//  NRFRCTableViewController.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRViewController.h"

@interface NRFRCTableViewController : NRViewController <UITableViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic) IBOutlet UITableView *tableView;

@end
