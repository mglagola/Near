//
//  NRInfoViewController.h
//  Near
//
//  Created by Mark Glagola on 6/30/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRFRCPickerViewController.h"

@interface NRInfoViewController : NRFRCPickerViewController <UICollectionViewDelegate>

@property (nonatomic) IBOutlet UISlider *rangeSlider;
@property (nonatomic) IBOutlet UISwitch *orderedSwitch;

@end
