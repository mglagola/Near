//
//  NROverlayView.m
//  Near
//
//  Created by Mark Glagola on 6/22/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NROverlayView.h"
#import "UILabel+Resize.h"

@implementation NROverlayView

@synthesize categoryLabel = _categoryLabel, nameLabel = _nameLabel, addressLabel = _addressLabel, milesLabel = _milesLabel, leftArrow = _leftArrow, rightArrrow = _rightArrrow;

- (void) initDefaults {
    [self.nameLabel setUniversalFontName:@"HelveticaNeue-Thin"];
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

- (void) clearOverlayContent {
    [self clearOverlayContent:YES];
}

- (void) clearOverlayContent:(BOOL)shouldClear {
    [self.subviews enumerateObjectsUsingBlock:^(UIView *subview, NSUInteger idx, BOOL *stop) {
        if ([subview isKindOfClass:[UILabel class]] && subview != self.rightArrrow && subview != self.leftArrow) {
            ((UILabel*)subview).text = @"";
        }
    }];
    self.rightArrrow.hidden = shouldClear;
    self.leftArrow.hidden = shouldClear;
}

- (void) relayout {
    UIFont *defaultFont = [UIFont fontWithName:@"HelveticaNeue-Thin" size:53];
    CGFloat height = [defaultFont lineHeight] * self.nameLabel.numberOfLines;
    [self.nameLabel adjustToSizeThatFits:CGSizeMake(self.nameLabel.width, height) font:defaultFont minFontSize:20];
    if (self.nameLabel.fontSize < 33) self.nameLabel.fontName = @"HelveticaNeue";
    else if (self.nameLabel.fontSize < 41) self.nameLabel.fontName = @"HelveticaNeue-Light";
    else self.nameLabel.fontName = @"HelveticaNeue-Thin";
    
    [self alignAndAdjustLabel:self.categoryLabel belowView:self.nameLabel];
    [self alignAndAdjustLabel:self.addressLabel belowView:self.categoryLabel];
    [self alignAndAdjustLabel:self.milesLabel belowView:self.addressLabel];
}

- (void) alignAndAdjustLabel:(UILabel*)label belowView:(UILabel*)topView {
    label.height = [label sizeThatFits:CGSizeMake(label.width, CGFLOAT_MAX)].height;
    [self alignView:label belowView:topView];
}

- (void) alignView:(UIView*)view belowView:(UIView*)topView {
    view.y = topView.bottom + 5;
}

@end
