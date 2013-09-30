//
//  NRFRCPickerViewController.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRFRCPickerViewController.h"

@interface NRFRCPickerViewController ()

@end

@implementation NRFRCPickerViewController

#pragma mark - UIPickerViewDataSource methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:component];
    return [sectionInfo numberOfObjects];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return [[self.fetchedResultsController sections] count];
}


#pragma mark - NSFetchedResultsControllerDelegate methods
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.pickerView reloadAllComponents];
}

@end
