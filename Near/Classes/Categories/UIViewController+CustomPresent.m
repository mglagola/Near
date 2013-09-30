//
//  UIViewController+CustomPresent.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "UIViewController+CustomPresent.h"

@implementation UIViewController (CustomPresent)

- (void) presentViewController:(UIViewController *)viewControllerToPresent {
    if ([UIDevice isIPAD])
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}

@end
