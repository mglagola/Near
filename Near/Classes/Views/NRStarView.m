//
//  NRStarView.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRStarView.h"

@implementation NRStarView

- (void) setDefaults {
    self.backgroundColor = [UIColor clearColor];
    self.color = [UIColor whiteColor];
}

- (id) init {
    return [super initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self setDefaults];
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    [self.color setFill];
    UIBezierPath *starPath = StarPath(self.frame);
    [starPath fill];
}


UIBezierPath *StarPath(CGRect frame) {
    
    float const offsetHeight = .33f;
    float const offsetWidth = .33f;
    
    UIBezierPath* bezierPath = [UIBezierPath bezierPath];
    
    [bezierPath moveToPoint: CGPointMake(frame.size.width*.5f, 0)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*.37, frame.size.height*offsetHeight)];
    
    [bezierPath addLineToPoint: CGPointMake(0, frame.size.height*offsetHeight)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*(offsetHeight), frame.size.height*.57f)];
    
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*.5f-frame.size.width*offsetWidth, frame.size.height*.9f)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*.5f, frame.size.height*.66f)];
    
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*.5f+frame.size.width*offsetWidth, frame.size.height*.9f)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*(offsetHeight*2), frame.size.height*.57f)];

    [bezierPath addLineToPoint: CGPointMake(frame.size.width, frame.size.height*offsetHeight)];
    [bezierPath addLineToPoint: CGPointMake(frame.size.width*(1-.37), frame.size.height*offsetHeight)];

    [bezierPath addLineToPoint: CGPointMake(frame.size.width*.5f, 0)];
    
    [bezierPath closePath];
    return bezierPath;
}

@end
