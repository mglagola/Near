//
//  NRFRCCollectionViewController.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRViewController.h"

@interface NRFRCCollectionViewController : NRViewController <UICollectionViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSFetchedResultsController *fetchedResultsController;

@end
