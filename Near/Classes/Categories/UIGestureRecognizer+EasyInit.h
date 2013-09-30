//
//  UIGestureRecognizer+EasyInit.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (EasyInit)

+ (void) createGestureInView:(UIView*)view delegate:(id<UIGestureRecognizerDelegate>)delegate subscribeNext:(void (^)(id x))nextBlock;
+ (void) createGestureInView:(UIView*)view subscribeNext:(void (^)(id x))nextBlock;

- (id) initSubscribeNext:(void (^)(id x))nextBlock;

@end
