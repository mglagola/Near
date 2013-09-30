//
//  NROverlayView.h
//  Near
//
//  Created by Mark Glagola on 6/22/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NROverlayView : UIView

@property (nonatomic, readonly) IBOutlet UILabel *categoryLabel;
@property (nonatomic, readonly) IBOutlet UILabel *nameLabel;
@property (nonatomic, readonly) IBOutlet UILabel *addressLabel;
@property (nonatomic, readonly) IBOutlet UILabel *milesLabel;
@property (nonatomic, readonly) IBOutlet UILabel *leftArrow;
@property (nonatomic, readonly) IBOutlet UILabel *rightArrrow;

- (void) clearOverlayContent;
- (void) clearOverlayContent:(BOOL)shouldClear;

- (void) relayout;

@end
