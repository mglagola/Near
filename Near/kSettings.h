//
//  kSettings.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

static NSString * const kFoursquareApiBaseURL = @"https://api.foursquare.com/v2/";

static NSString * const kFoursquareApiVenueSuffix = @"venues/";
static NSString * const kFoursquareApiVenueSearchSuffix = @"search/";
static NSString * const kFoursquareApiVenueMenuSuffix = @"menu/";

static NSString * const kFoursquareFoodCategoryId = @"4d4b7105d754a06374d81259"; //food id
static NSString * const kFoursquareApiTimestamp = @"20130621"; //YYYYMMDD

#define METERS_TO_MILES(__METERS__) ((__METERS__) * 0.000621371f)
#define MILES_TO_METERS(__MILES__) ((__MILES__) * 1609.34f)
