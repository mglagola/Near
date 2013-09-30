//
//  NRButtonContainerView.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRButtonBarView.h"
#import <FontAwesomeKit/FontAwesomeKit.h>

#define FAKIconMore @"\uf013"

@implementation NRButtonBarView

@synthesize nextButton = _nextButton, previousButton = _previousButton, moreButton = _moreButton, refreshButton = _refreshButton, menuButton = _menuButton;

- (void) initDefaults {
    UIFont *awesomeFont = [FontAwesomeKit fontWithSize:self.menuButton.titleLabel.fontSize];
    self.menuButton.titleLabel.font = awesomeFont;
    [self.menuButton setTitle:FAKIconThList forState:UIControlStateNormal];
    
    self.moreButton.titleLabel.font = awesomeFont;
    [self.moreButton setTitle:FAKIconExternalLink forState:UIControlStateNormal];
    
    self.previousButton.titleLabel.font = awesomeFont;
    [self.previousButton setTitle:FAKIconArrowLeft forState:UIControlStateNormal];
    
    self.nextButton.titleLabel.font = awesomeFont;
    [self.nextButton setTitle:FAKIconArrowRight forState:UIControlStateNormal];
    
    self.refreshButton.titleLabel.font = awesomeFont;
    [self.refreshButton setTitle:FAKIconRefresh forState:UIControlStateNormal];
}

- (id) init {
    return [self initWithFrame:CGRectZero];
}

- (id) initWithFrame:(CGRect)frame {
    if (self = [super init])
        [self initDefaults];
    return self;
}

- (void) awakeFromNib {
    [super awakeFromNib];
    [self initDefaults];
}

- (void) hideAllButtons:(BOOL)shouldHide {
    [self hideButtons:shouldHide includingMenuButton:YES];
}


- (void) hideButtons:(BOOL)shouldHide includingMenuButton:(BOOL)isMenuIncluded {
    self.nextButton.hidden = shouldHide;
    self.previousButton.hidden = shouldHide;
    self.moreButton.hidden = shouldHide;
    self.refreshButton.hidden = shouldHide;
    
    if (isMenuIncluded)
        self.menuButton.hidden = shouldHide;
}

@end
