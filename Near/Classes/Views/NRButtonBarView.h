//
//  NRButtonContainerView.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NRButtonBarView : UIView

@property (nonatomic, readonly) IBOutlet UIButton *nextButton;
@property (nonatomic, readonly) IBOutlet UIButton *previousButton;
@property (nonatomic, readonly) IBOutlet UIButton *menuButton;
@property (nonatomic, readonly) IBOutlet UIButton *moreButton;
@property (nonatomic, readonly) IBOutlet UIButton *refreshButton;

- (void) hideAllButtons:(BOOL)shouldHide;
- (void) hideButtons:(BOOL)shouldHide includingMenuButton:(BOOL)isMenuIncluded;

@end
