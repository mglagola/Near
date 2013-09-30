//
//  NRGeneratorViewController.m
//  Near
//
//  Created by Mark Glagola on 6/21/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRGeneratorViewController.h"
#import "Venue.h"
#import "NRImageCollectionCell.h"
#import "Photo.h"
#import "NRInfoViewController.h"
#import "NRScrollView.h"
#import "UIGestureRecognizer+EasyInit.h"
#import "Menu.h"
#import "NRStarView.h"
#import "NRDataFetcher.h"
#import "NRMenuViewController.h"
#import "VenueCategory.h"
#import "UILabel+Resize.h"
#import <FontAwesomeKit/FontAwesomeKit.h>
#import "NROverlayView.h"
#import "NRButtonBarView.h"

static int const MAP_INDEX_SECTION = 0;
static int const IMAGE_INDEX_SECTION = 1;

@interface NRGeneratorViewController () {
    IBOutlet NRButtonBarView *buttonBarView;
    IBOutlet NROverlayView *overlayView;
    
    BOOL isFirstLocationUpdate;
    BOOL isScrolling;
    
    CGPoint beforeContentOffset;
}
@end

@implementation NRGeneratorViewController

@synthesize locationManager = _locationManager, recentLocation = _recentLocation, isShowingOverlay = _isShowingOverlay;

- (CLLocationManager*) locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.distanceFilter = kCLDistanceFilterNone;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    }
    return _locationManager;
}

- (void) initReactiveBlocks {
    [RACAble(self.isShowingOverlay) subscribeNext:^(id x) {
        self.collectionView.scrollEnabled = self.isShowingOverlay;
    }];
    
    [RACAble(self.venue.menu) subscribeNext:^(id x) {
        buttonBarView.menuButton.hidden = self.venue.menu ? NO : YES;
    }];
    
    [RACAble(self.venue) subscribeNext:^(id x) {
        if (!self.recentLocation)
            return;
        
        [self updateDistanceLabel];
        [self refreshFRC];
        [self refreshOverlay];
    }];
    
    [RACAble(self.venue.areDetailsSynced) subscribeNext:^(id x) {
        [self refreshOverlay];
    }];
    
    [RACAble(self.recentLocation) subscribeNext:^(id x) {
        if (!self.venue)
            return;
        [self updateDistanceLabel];
    }];
    
    RACSignal *userDefaultsSignal = [RACSignal merge:@[
        [[NSUserDefaults standardUserDefaults] rac_signalForKeyPath:kUserDefaultsRangeKey observer:self],
        [[NSUserDefaults standardUserDefaults] rac_signalForKeyPath:kUserDefaultsVenueCategoryIdKey observer:self],
        [[NSUserDefaults standardUserDefaults] rac_signalForKeyPath:kUserDefaultsOrderedResultsKey observer:self]
         ]];
    
    [[userDefaultsSignal filter:^BOOL(id value) {
        return ![NRDataFetcher shared].isFetching;
    }] subscribeNext:^(id x) {
        [self fetchData];
    }];
}

- (void) initCollectionViewDefaults {
    Class cellClass = [NRImageCollectionCell class];
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:NSStringFromClass(cellClass)];
    self.collectionView.backgroundColor = [UIColor clearColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = self.view.size;
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.collectionViewLayout = layout;
}

- (void) initGestures {
    [UITapGestureRecognizer createGestureInView:self.view subscribeNext:^(UITapGestureRecognizer *gesture) {
        CGPoint tapPoint = [gesture locationInView:self.view];
        UIView *tappedView = [self.view hitTest:tapPoint withEvent:nil];
        if ([tappedView isKindOfClass:[UIButton class]])
            return;
        
        [self setOverlayViewsHidden:self.isShowingOverlay];
    }];
    
    [UIPinchGestureRecognizer createGestureInView:self.view delegate:self subscribeNext:^(UIPinchGestureRecognizer *gesture) {
        [self setOverlayViewsHidden:YES];
    }];
}

- (void) viewDidLoad {
    [super viewDidLoad];
    
    if (![UIDevice isIPAD]) {
        overlayView.size = self.view.size;
        self.collectionView.size = self.view.size;
        buttonBarView.y = self.view.size.height - buttonBarView.size.height - 8;
    }
    
    isFirstLocationUpdate = YES;
    _isShowingOverlay = YES;
    
    [self.locationManager startUpdatingLocation];
    
    [self initCollectionViewDefaults];
    
    [self clearViews];

    [self initReactiveBlocks];
    
    [[NRDataFetcher shared] setVenusLoadedHandler:^(Venue *venue) {
        self.venue = venue;
    }];

    [self initGestures];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [overlayView relayout];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void) updateDistanceLabel {
    CLLocationDistance milesToDest = METERS_TO_MILES([self.recentLocation distanceFromLocation:self.venue.location]);
    overlayView.milesLabel.text = [NSString stringWithFormat:@"%.01f mi", milesToDest];
}

- (void) clearViews {
    [self clearViews:YES];
}

- (void) clearViews:(BOOL)shouldClear {
    [overlayView clearOverlayContent:shouldClear];
    [buttonBarView hideButtons:shouldClear includingMenuButton:shouldClear];
    [[UIApplication sharedApplication] setStatusBarHidden:shouldClear withAnimation:UIStatusBarAnimationSlide];
}

- (void) fetchData {
    [[NRDataFetcher shared] fetchData:self.recentLocation start:^{
        [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    } success:^{
        [self clearViews:NO];
        [SVProgressHUD dismiss];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (error) [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@",[error localizedDescription]]];
        else [SVProgressHUD dismiss];
    } completion:^{
    
    }];
}

- (void) refreshFRC {
    self.fetchedResultsController = [Photo MR_fetchAllSortedBy:@"createdAtTimestamp"
                                                     ascending:NO
                                                 withPredicate:[NSPredicate predicateWithFormat:@"venue == %@", self.venue]
                                                       groupBy:nil
                                                      delegate:self];
}

#pragma mark - Relayout Methods
- (void) refreshOverlay {
    overlayView.nameLabel.text = self.venue.name;
    overlayView.addressLabel.text = self.venue.address;
    
    //Get appropriate category list string that doesn't surpass the label width
    NSArray *categories = [self.venue.categories allObjects];
    VenueCategory *primaryCategory = self.venue.primaryCategory;
    NSString *categoryListString = primaryCategory.name;
    CGFloat maxWidth = overlayView.categoryLabel.width;
    for (int i = 0; i < [categories count]; i++) {
        VenueCategory *category = [categories objectAtIndex:i];
        if (category == primaryCategory)
            continue;
        
        NSString *temp = [categoryListString stringByAppendingFormat:@", %@", category.shortName];
        overlayView.categoryLabel.text = temp;
        CGFloat newWidth = [overlayView.categoryLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, overlayView.categoryLabel.height)].width;
        if (newWidth > maxWidth) {
            break;
        } else {
            categoryListString = temp;
        }
    }
    overlayView.categoryLabel.text = categoryListString;
    
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    [self setOverlayViewsHidden:NO];
    [self refreshArrowsForPage:0];
    [overlayView relayout];
}

#pragma mark - Overlay view handling methods
- (void) __setOverlayViewsAlpha:(CGFloat)alpha {
    buttonBarView.alpha = alpha;
    overlayView.alpha = alpha;
}

- (void) setOverlayViewsHidden:(BOOL)hidden animated:(BOOL)animated{
    if ((hidden && !self.isShowingOverlay) || (!hidden && self.isShowingOverlay))
        return;
    
    CGFloat alpha = hidden ? 0 : 1;
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            [self __setOverlayViewsAlpha:alpha];
        }];
    } else {
        [self __setOverlayViewsAlpha:alpha];
    }
                
    _isShowingOverlay = !hidden;
    [[UIApplication sharedApplication] setStatusBarHidden:hidden withAnimation:UIStatusBarAnimationSlide];
    
    //Toggle maps scroll ability based on focus or not
    if (!self.isShowingOverlay && !isScrolling) {
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
            if ([self.collectionView indexPathForCell:cell].section == MAP_INDEX_SECTION) {
                ((NRImageCollectionCell *)cell).mapView.scrollEnabled = YES;
            }
        }];
    } else {
        [self.collectionView.visibleCells enumerateObjectsUsingBlock:^(UICollectionViewCell* cell, NSUInteger idx, BOOL *stop) {
            if ([self.collectionView indexPathForCell:cell].section == MAP_INDEX_SECTION) {
                ((NRImageCollectionCell *)cell).mapView.scrollEnabled = NO;
            }
        }];
    }
    
}

- (void) setOverlayViewsHidden:(BOOL)hidden {
    [self setOverlayViewsHidden:hidden animated:YES];
}

- (void) refreshArrowsForPage:(int)page {
    overlayView.leftArrow.hidden = (page == 0);
    
    int numberOfPages = 0;
    for (int i = 0; i < [self numberOfSectionsInCollectionView:self.collectionView]; i++)
        numberOfPages += [self.collectionView numberOfItemsInSection:i];
    
    overlayView.rightArrrow.hidden = (page + 1 > numberOfPages-1);
}


#pragma mark - rotation methods
- (void) willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    CGSize itemSize = [UIScreen screenRect].size;
    beforeContentOffset = self.collectionView.contentOffset;
    beforeContentOffset.x = beforeContentOffset.x / itemSize.width;
    beforeContentOffset.y = beforeContentOffset.y / itemSize.height;
}

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    CGSize itemSize = [UIScreen screenRect].size;
    CGPoint newContentOffset = CGPointMake(beforeContentOffset.x * itemSize.width,
                                           beforeContentOffset.y * itemSize.height);
    [self.collectionView reloadData];
    [self.collectionView setContentOffset:newContentOffset];
    [overlayView relayout];
}

#pragma mark - Action Methods
- (void)launchSettings {
    [self presentViewController:[[NRInfoViewController alloc] init]];
    [self setOverlayViewsHidden:NO animated:NO];
}

- (void) launchDirections {
    [SVProgressHUD showWithStatus:@"Loading..." maskType:SVProgressHUDMaskTypeGradient];
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:self.recentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = [placemarks firstObject];
        if (!placemark || error) {
            [SVProgressHUD showErrorWithStatus:@"Error!"];
            return;
        }
        [SVProgressHUD dismiss];
        NSString *currentAddress = [[NSString stringWithFormat:@"%@, %@", [placemark.addressDictionary valueForKey:@"Street"], [placemark.addressDictionary valueForKey:@"State"]] stringByReplacingOccurrencesOfString:@" " withString:@"+"];
        
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://maps.apple.com/?daddr=%@&saddr=%@", self.venue.mapsAddress, currentAddress]];
        [[UIApplication sharedApplication] openURL:url];
    }];
    
}

- (void) callVenue {
    [[UIApplication sharedApplication] openURL:self.venue.phoneNumberURL];
}

- (IBAction)nextButtonPressed:(id)sender {
    self.venue = [[NRDataFetcher shared] nextVenue];
}

- (IBAction)prevButtonPressed:(id)sender {
    self.venue = [[NRDataFetcher shared] previousVenue];
}

- (IBAction)menuButtonPressed:(id)sender {
    [self presentViewController:[[NRMenuViewController alloc] initWithVenue:self.venue]];
}

- (IBAction)refreshButtonPressed:(id)sender {
    [self fetchData];
}

- (IBAction)moreButtonPressed:(id)sender {
    UIActionSheet *action;
    if (self.venue.phoneNumber && [[UIApplication sharedApplication] canOpenURL:self.venue.phoneNumberURL])
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Call", @"Directions", @"Settings", nil];
    else
        action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Directions", @"Settings", nil];
    
    CGRect rect = buttonBarView.moreButton.frame;
    rect.origin.x -= 15;
    
    if ([UIDevice isIPAD])
        [action showFromRect:rect inView:self.view animated:YES];
    else
        [action showInView:self.view];
}

#pragma mark - CLLocationManagerDelegate methods
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.recentLocation = [locations lastObject];
    
    if (isFirstLocationUpdate) {
        isFirstLocationUpdate = NO;
        [self fetchData];
    }
}

#pragma mark - UICollectionView datasource methods
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NRImageCollectionCell *cell = [cv dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NRImageCollectionCell class]) forIndexPath:indexPath];
    
    if (indexPath.section == MAP_INDEX_SECTION) {
        [cell setRegion:self.recentLocation toDestination:self.venue.location title:self.venue.name];
    } else if (indexPath.section == IMAGE_INDEX_SECTION){
        Photo *photo = [self.fetchedResultsController objectAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
        [cell setImageWithURL:[NSURL URLWithString:photo.url]];
    }
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section == MAP_INDEX_SECTION)
        return 1;
    else if (section == IMAGE_INDEX_SECTION)
        return [[self.fetchedResultsController sections][0] numberOfObjects];
    else
        return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    isScrolling = YES;
}
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    isScrolling = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView {
    float offset = scrollView.contentOffset.x / scrollView.size.width;
    if (offset <= .5f) {
        [self setOverlayViewsHidden:NO];
    } else {
        [self setOverlayViewsHidden:YES];
    }
    [self refreshArrowsForPage:(int)offset];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [UIScreen screenRect].size;
}

#pragma mark - UIGestureRecognizerDelegate methods
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    return YES;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return  YES;
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return  YES;
}

#pragma mark - UIActionSheetDelegate methods
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *title = [[actionSheet buttonTitleAtIndex:buttonIndex] lowercaseString];
    if ([title isEqualToString:@"settings"]) {
        [self launchSettings];
    } else if ([title isEqualToString:@"directions"]) {
        [self launchDirections];
    } else if ([title isEqualToString:@"call"]) {
        [self callVenue];
    }
}

@end
