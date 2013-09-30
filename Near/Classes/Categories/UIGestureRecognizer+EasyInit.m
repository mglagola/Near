//
//  UIGestureRecognizer+EasyInit.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "UIGestureRecognizer+EasyInit.h"

@implementation UIGestureRecognizer (EasyInit)

+ (void) createGestureInView:(UIView*)view delegate:(id<UIGestureRecognizerDelegate>)delegate subscribeNext:(void (^)(id x))nextBlock{
    UIGestureRecognizer *gesture = [[self alloc] initSubscribeNext:nextBlock];
    gesture.delegate = delegate;
    [view addGestureRecognizer:gesture];
}

+ (void) createGestureInView:(UIView*)view subscribeNext:(void (^)(id x))nextBlock {
    [self createGestureInView:view delegate:nil subscribeNext:nextBlock];
}

- (id) initSubscribeNext:(void (^)(id x))nextBlock {
    if (self = [self init]) {
        self.cancelsTouchesInView = NO;
        [self.rac_gestureSignal subscribeNext:nextBlock];
    }
    return self;
}


@end
