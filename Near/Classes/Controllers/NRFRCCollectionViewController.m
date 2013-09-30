//
//  NRFRCCollectionViewController.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRFRCCollectionViewController.h"

@interface NRFRCCollectionViewController ()
@end

@implementation NRFRCCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource methods
- (UICollectionViewCell*) collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:NSInternalInconsistencyException format:@"You should override cellForItemAtIndexPath: in subclass"];
    return nil;
}

- (NSInteger) collectionView:(UICollectionView *)aCollectionView numberOfItemsInSection:(NSInteger)section {
    id  sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)aCollectionView {
    return  [[self.fetchedResultsController sections] count];
}

#pragma mark - NSFetchedResultsController Delegate
- (void) controllerWillChangeContent:(NSFetchedResultsController *)controller {
    
}

- (void) controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.collectionView reloadData];
}

@end
