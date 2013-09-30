//
//  NRInfoViewController.m
//  Near
//
//  Created by Mark Glagola on 6/30/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRInfoViewController.h"
#import "VenueCategory.h"
#import "NRCategoryCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NRInfoViewController () {
    IBOutlet UILabel *rangeLabel;
    IBOutlet UILabel *titleLabel;
    
    float rangeSliderValue;
    BOOL orderedResults;
    NSString *venueCategoryId;
    
    NSIndexPath *selectedIndexPath;
    IBOutlet UIButton *closeButton;
    IBOutlet UIButton *saveButton;
}

@end

@implementation NRInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rangeSliderValue = -1;
    
    self.rangeSlider.value = [NSUserDefaults range];
    [self refreshRangeLabel];
    
    [titleLabel setUniversalFontName:@"HelveticaNeue-Thin"];
    
    [[self.rangeSlider rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(UISlider* slider) {
        rangeSliderValue = slider.value;
        [self refreshRangeLabel];
    }];
    
    orderedResults = [NSUserDefaults isOrderedResults];
    self.orderedSwitch.on = orderedResults;
    
    venueCategoryId = [NSUserDefaults venueCategoryId];
    
    self.fetchedResultsController = [VenueCategory MR_fetchAllSortedBy:@"name" ascending:NO withPredicate:[NSPredicate predicateWithFormat:@"isSubcategory == NO"] groupBy:nil delegate:self];
    
    [[self.fetchedResultsController fetchedObjects] enumerateObjectsUsingBlock:^(VenueCategory *category, NSUInteger idx, BOOL *stop) {
        if ([category.identifier isEqualToString:[NSUserDefaults venueCategoryId]])
            selectedIndexPath = [NSIndexPath indexPathForRow:idx inSection:0];
    }];
    
    [self.pickerView selectRow:selectedIndexPath.row inComponent:selectedIndexPath.section animated:NO];
    
    if ([UIDevice isBelowiOS7] && ![UIDevice isIPAD]) {
        self.view.autoresizesSubviews = NO;
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if (![view isKindOfClass:[UIButton class]])
                view.y -= statusBarHeight;
        }];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![UIDevice isIPAD])
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void) refreshRangeLabel {
    rangeLabel.text = [NSString stringWithFormat:@"%.01f mi", self.rangeSlider.value];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveButtonPressed:(id)sender {
    
    VenueCategory *item = [self.fetchedResultsController objectAtIndexPath:selectedIndexPath];
    if (selectedIndexPath && ![item.identifier isEqualToString:venueCategoryId]) {
        venueCategoryId = item.identifier;
    }
    
    if (rangeSliderValue > 0)
        [NSUserDefaults setRange:rangeSliderValue];
    if (orderedResults != self.orderedSwitch.on)
        [NSUserDefaults setOrderedResults:self.orderedSwitch.on];
    if (![venueCategoryId isEqualToString:[NSUserDefaults venueCategoryId]])
        [NSUserDefaults setVenueCategoryId:venueCategoryId];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UIPickerViewDelegate methods
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    VenueCategory *category = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:component]];
    return category.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedIndexPath = [NSIndexPath indexPathForRow:row inSection:component];
}

@end
