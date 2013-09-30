//
//  GBDataFetcher.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRDataFetcher.h"
#import "Venue.h"
#import "Menu.h"
#import "Photo.h"
#import "VenueCategory.h"

@interface NRDataFetcher()

@property (nonatomic, readonly) NSMutableArray *detailOperations;

@end

@implementation NRDataFetcher

@synthesize venues = _venues, currentVenueIndex = _currentVenueIndex, isFetching = _isFetching, detailOperations = _detailOperations;

+ (instancetype) shared {
    static NRDataFetcher *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (NSMutableArray*) detailOperations {
    if (!_detailOperations)
        _detailOperations = [[NSMutableArray alloc] init];
    return _detailOperations;
}

- (id) init {
    if (self = [super init]) {
        _currentVenueIndex = 0;
        
        //Listesn for current venue index change
        //On change, if venue details has not yet been fetched, they will be fetched.
        [RACAble(self.currentVenueIndex) subscribeNext:^(id x) {
            
            if ([self.venues count] == 0)
                return;
            
            Venue *venue = [self.venues objectAtIndex:self.currentVenueIndex];
            
            if (venue.areDetailsSynced.boolValue == YES)
                return;
            
            void (^ onFail) (NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON, id<RACSubscriber> subscriber) = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON, id<RACSubscriber> subscriber) {
                venue.areDetailsSynced = @NO;
                [subscriber sendCompleted];
                NSLog(@"Failed to fetch details - %@", [error localizedDescription]);
            };
            
            //cancel previous operations
            if ([self.detailOperations count] > 0) {
                [self.detailOperations enumerateObjectsUsingBlock:^(AFJSONRequestOperation *operation, NSUInteger idx, BOOL *stop) {
                    [operation cancel];
                }];
            }
            
            RACSignal *venueDetailOperation = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
                AFJSONRequestOperation *operation = [AFJSONRequestOperation startFoursquareExtraDetailVenueJSONRequestOperationWithLocation:venue success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    NSArray *venueDetails = [JSON valueForKeyPath:@"response.venue"];
                    [Venue venueWithJSON:venueDetails context:[NSManagedObjectContext MR_contextForCurrentThread]];
                    [[[venueDetails valueForKeyPath:@"photos.groups.items"] firstObject] enumerateObjectsUsingBlock:^(id photoJSON, NSUInteger idx, BOOL *stop) {
                        [Photo photoWithJSON:photoJSON venue:venue context:[NSManagedObjectContext MR_contextForCurrentThread]];
                    }];
                    
                    NSMutableArray *categories = [NSMutableArray array];
                    [[venueDetails valueForKey:@"categories"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [categories addObject:[VenueCategory categoryWithJSON:obj context:[NSManagedObjectContext MR_contextForCurrentThread]]];
                    }];
                    [venue setCategories:[NSSet setWithArray:categories]];
                    
                    [subscriber sendCompleted];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    onFail(request, response, error, JSON, subscriber);
                }];
                
                [self.detailOperations addObject:operation];
            }];
            
            
            RACSignal *menuOperation = [RACSignal startLazilyWithScheduler:[RACScheduler scheduler] block:^(id<RACSubscriber> subscriber) {
                AFJSONRequestOperation *operation = [AFJSONRequestOperation startFoursquareVenueMenuJSONRequestOperationForVenue:venue success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                    NSArray *menuJSON = [JSON valueForKeyPath:@"response.menu.menus.items"];
                    [menuJSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        [Menu menuWithJSON:obj venue:venue context:[NSManagedObjectContext MR_contextForCurrentThread]];
                    }];
                    [subscriber sendCompleted];
                } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
                    onFail(request, response, error, JSON, subscriber);
                }];
                
                [self.detailOperations addObject:operation];
            }];
            
            [[RACSignal combineLatest:@[menuOperation, venueDetailOperation]] subscribeCompleted:^{
                venue.areDetailsSynced = @YES;
                [MagicalRecord saveWithBlockAndWait:nil];
                NSLog(@"Successful details fetch");
            }];

        }];
    }
    return self;
}

- (void) fetchData:(CLLocation*)location {
    [self fetchData:location success:nil failure:nil];
}

- (void) fetchData:(CLLocation*)location success:(void (^) (void))success failure:(FailureBlock)failure {
    [self fetchData:location start:nil success:success failure:failure completion:nil];
}

- (void) fetchData:(CLLocation*)location start:(void (^) (void))start success:(void (^) (void))success failure:(FailureBlock)failure completion:(void (^) (void))completion {
    
    if (self.isFetching) {
        NSDictionary *json = @{@"isFetching": @YES, @"message" : @"already fetching data"};
        failure(nil, nil, nil, json);
        return;
    }
    
    FailureBlock _fail = ^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        _isFetching = NO;
        failure(request, response, error, JSON);
        completion();
    };

    start();
    _isFetching = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSManagedObjectContext *context = [NSManagedObjectContext MR_contextForCurrentThread];
        [AFJSONRequestOperation startFoursquareVenueCategoryJSONRequestOperationWithSuccess:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
            [[JSON valueForKeyPath:@"response.categories"] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                VenueCategory *category = [VenueCategory categoryWithJSON:obj context:context];
                category.isSubcategory = @NO;
            }];
            
            int radius = MILES_TO_METERS([NSUserDefaults range]);
            [AFJSONRequestOperation startFoursquareVenueSearchJSONRequestOperationWithLocation:location radius:radius success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
                
                //successful fetch - delete other data
                //Deleting venue data removes all data besides VenueCategories
                [Venue MR_truncateAll];
                
                
                NSMutableArray *allVenues = [NSMutableArray array];
                NSArray *venues = [JSON valueForKeyPath:@"response.venues"];
                [venues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                    [allVenues addObject:[Venue venueWithJSON:obj context:context]];
                }];
                
                [context MR_saveOnlySelfWithCompletion:^(BOOL isSuccessful, NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        _isFetching = NO;
                        [self loadVenueData];
                        success();
                        completion();
                    });
                }];
                
            } failure:_fail];
        } failure:_fail];
    });
    
}

/*
 * Loads venue data and sends venue from ordered/nonordered list of venues
 */
- (void) loadVenueData {
    BOOL isOrdered = [NSUserDefaults isOrderedResults];
    _venues = isOrdered ? [Venue MR_findAllSortedBy:@"distance" ascending:YES] : [Venue MR_findAll];
    self.currentVenueIndex = 0;
    if (self.venues.count > self.currentVenueIndex)
        self.venusLoadedHandler([self.venues objectAtIndex:self.currentVenueIndex]);
}

- (Venue*) nextVenue {
    if (self.currentVenueIndex + 1 >= self.venues.count) {
        self.currentVenueIndex = 0;
    } else {
        self.currentVenueIndex++;
    }
    return [self.venues objectAtIndex:self.currentVenueIndex];
}

- (Venue*) currentVenue {
    return [self.venues objectAtIndex:self.currentVenueIndex];
}

- (Venue*) previousVenue {
    if (self.currentVenueIndex-1 < 0) {
        self.currentVenueIndex = self.venues.count-1;
    } else {
        self.currentVenueIndex--;
    }
    return [self.venues objectAtIndex:self.currentVenueIndex];
}

@end
