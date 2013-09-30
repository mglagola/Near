//
//  NRCategoryCell.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRCategoryCell.h"

@implementation NRCategoryCell

@synthesize imageView = _imageView, titleLabel = _titleLabel;

- (UILabel*) titleLabel {
    if (!_titleLabel) {
        int padding = 5;
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(padding, 0, self.contentView.width-padding*2, 0)];
        _titleLabel.fontSize = 13.0f;
        _titleLabel.text = @"title";
        _titleLabel.height = [_titleLabel sizeThatFits:CGSizeMake(_titleLabel.width, CGFLOAT_MAX)].height;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIImageView*) imageView {
    if (!_imageView) {
        CGFloat height =  self.contentView.frame.size.width- self.titleLabel.height;
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, height <= self.contentView.width ? height : self.contentView.width,  height)];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        CGPoint center = _imageView.center;
        center.x = self.contentView.center.x;
        _imageView.center = center;
        self.contentView.clipsToBounds = YES;
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.y = self.imageView.height + 1;
    }
    return self;
}

@end
