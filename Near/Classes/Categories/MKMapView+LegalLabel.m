//
//  MKMapView+LegalLabel.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "MKMapView+LegalLabel.h"

@implementation MKMapView (LegalLabel)

- (void) moveLegalLabelTo:(CGPoint)point {
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[UILabel class]]) {
            subview.frame = CGRectMake(point.x, point.y, subview.frame.size.width, subview.frame.size.height);
            subview.hidden = YES;
            break;
        }
    }
}

@end
