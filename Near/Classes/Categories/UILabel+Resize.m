//
//  UILabel+FontSize.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "UILabel+Resize.h"

@implementation UILabel (Resize)

- (void) adjustToSizeThatFits:(CGSize)size font:(UIFont*)font minFontSize:(CGFloat)minFontSize{
    CGFloat actualFontSize;
    [self.text sizeWithFont:font minFontSize:minFontSize actualFontSize:&actualFontSize forWidth:size.width+size.height lineBreakMode:NSLineBreakByTruncatingTail];
    
    if (actualFontSize == 0)
        return;
    
    self.fontSize = actualFontSize;
    self.height = [self sizeThatFits:size].height;
}

@end
