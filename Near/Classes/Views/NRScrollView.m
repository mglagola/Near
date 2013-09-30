//
//  NRScrollView.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRScrollView.h"

@implementation NRScrollView

@synthesize touchStateChangedHandler = _touchStateChangedHandler;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self callHandlerWithSate:NRScrollViewTouchStateBegan touches:touches event:event];
}

- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self callHandlerWithSate:NRScrollViewTouchStateMoved touches:touches event:event];
}

- (void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self callHandlerWithSate:NRScrollViewTouchStateEnded touches:touches event:event];
}

- (void) touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self callHandlerWithSate:NRScrollViewTouchStateCanceled touches:touches event:event];
}

- (void) callHandlerWithSate:(NRScrollViewTouchState)state touches:(NSSet*)touches event:(UIEvent*)event {
    self.touchStateChangedHandler(state, touches, event);
}

@end
