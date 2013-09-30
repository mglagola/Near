//
//  NRMenuViewController.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRMenuViewController.h"
#import "MenuSection.h"
#import "MenuItem.h"
#import "Venue.h"
#import "NRMenuCell.h"
#import "NRMenuSectionView.h"
#import "VenueCategory.h"
#import "UILabel+Resize.h"

@interface NRMenuViewController () {
    Venue *venue;
    IBOutlet UIButton *closeButton;
    IBOutlet UILabel *titleLabel;
}

@end

@implementation NRMenuViewController

- (id) initWithVenue:(Venue*)v {
    if (self = [super initWithNib]) {
        venue = v;
    }
    return self;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (![UIDevice isIPAD])
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    closeButton.layer.shadowRadius = 1.5f;
    closeButton.layer.shadowOffset = CGSizeMake(0, -1);
    closeButton.layer.shadowOpacity = 0.5f;
    
    titleLabel.text = venue.name;

    self.fetchedResultsController = [MenuItem MR_fetchAllSortedBy:@"menuSection.name" ascending:YES withPredicate:[NSPredicate predicateWithFormat:@"menu == %@", venue.menu] groupBy:@"menuSection.name" delegate:self];
    [self.tableView reloadData];
    
    if ([UIDevice isBelowiOS7]) {
        self.view.autoresizesSubviews = NO;
        CGFloat statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
        [self.view.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
            if ([view isKindOfClass:[UIButton class]])
                view.width = self.view.width;
            else
                view.y -= statusBarHeight;
            
            if ([view isKindOfClass:[UITableView class]])
                view.height += statusBarHeight;
            
        }];
    }
    
    [titleLabel setUniversalFontName:@"HelveticaNeue-Thin"];
}

- (IBAction)closeButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITableView delegate/datasource methods
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellId = @"cell";
    NRMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    if (!cell) {
        CGSize size = CGSizeMake(tableView.width, [self tableView:tableView heightForRowAtIndexPath:indexPath]);
        cell = [[NRMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellId size:size];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    MenuItem *item = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.titleLabel.text = item.name;
    cell.subtitleLabel.text = (item.price.floatValue > 0) ? [NSString stringWithFormat:@"$%.02f", item.price.floatValue] : @"";
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    MenuItem *item = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    NRMenuSectionView *sectionView = [[NRMenuSectionView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 50)];
    sectionView.titleLabel.text = item.menuSection.name;
    return sectionView;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

@end
