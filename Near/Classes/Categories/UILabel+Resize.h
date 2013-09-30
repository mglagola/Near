//
//  UILabel+FontSize.h
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Resize)

- (void) adjustToSizeThatFits:(CGSize)size font:(UIFont*)font minFontSize:(CGFloat)minFontSize;

@end
