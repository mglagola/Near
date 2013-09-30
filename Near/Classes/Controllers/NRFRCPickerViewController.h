//
//  NRFRCPickerViewController.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRViewController.h"

@interface NRFRCPickerViewController : NRViewController <UIPickerViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
