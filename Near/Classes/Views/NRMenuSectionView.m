//
//  NRMenuSectionView.m
//  Near
//
//  Created by Mark Glagola on 6/27/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRMenuSectionView.h"

@implementation NRMenuSectionView

@synthesize titleLabel = _titleLabel;

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.minimumScaleFactor = .65f;
        _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:26];
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (id) init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        int padding = 10;
        frame.origin.x = padding;
        frame.size.width -= padding;
        self.titleLabel.frame = frame;
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.layer.shadowOpacity = 0.5f;
        self.layer.shadowOffset = CGSizeMake(0, 1.5f);
        self.layer.shadowRadius = 1.5f;
    }
    return self;
}

@end
