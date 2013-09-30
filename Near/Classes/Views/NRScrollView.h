//
//  NRScrollView.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    NRScrollViewTouchStateBegan = 0,
    NRScrollViewTouchStateMoved,
    NRScrollViewTouchStateEnded,
    NRScrollViewTouchStateCanceled
}NRScrollViewTouchState;

typedef void (^TouchStateChanged)(NRScrollViewTouchState state, NSSet* touches, UIEvent *event);

@interface NRScrollView : UIScrollView

@property (readwrite, copy) TouchStateChanged touchStateChangedHandler;

@end
