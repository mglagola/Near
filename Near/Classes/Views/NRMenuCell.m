
//
//  NRMenuCell.m
//  Near
//
//  Created by Mark Glagola on 6/27/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRMenuCell.h"

@implementation NRMenuCell

@synthesize subtitleLabel = _subtitleLabel, titleLabel = _titleLabel;

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.fontSize = 18.0f;
        _titleLabel.minimumScaleFactor = .65f;
        [self addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel*) subtitleLabel {
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 0, 0)];
        _subtitleLabel.backgroundColor = [UIColor clearColor];
        _subtitleLabel.fontSize = 16.0f;
        _subtitleLabel.minimumScaleFactor = .65f;
        _subtitleLabel.textColor = [UIColor darkGrayColor];
        _subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:_subtitleLabel];
    }
    return _subtitleLabel;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier size:(CGSize)size{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        int padding = 15;
        self.titleLabel.frame = CGRectMake(padding, 0, size.width*.75-padding, size.height);
        self.subtitleLabel.frame = CGRectMake(size.width*.75+padding, 0, size.width*.25-padding*2, size.height);
    }
    return self;
}

@end
