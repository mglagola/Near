//
//  UILabel+FontName.m
//  Near
//
//  Created by Mark Glagola on 6/24/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "UILabel+FontName.h"
#import <iOS-Extensions/UILabel+Font.h>

@implementation UILabel (FontName)

- (void) setUniversalFontName:(NSString *)fontName {
    if ([fontName isEqualToString:@"HelveticaNeue-Thin"] && [UIDevice isBelowiOS7])
        fontName = @"HelveticaNeue-Light";
    self.fontName = fontName;
}

@end
