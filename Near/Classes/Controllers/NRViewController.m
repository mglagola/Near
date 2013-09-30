//
//  NRViewController.m
//  Near
//
//  Created by Mark Glagola on 6/21/13.
//  Copyright (c) 2013 Mark Glagola. All rights reserved.
//

#import "NRViewController.h"

@interface NRViewController ()

@end

@implementation NRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (![UIDevice isIPAD]) {
        self.view.size = [UIScreen screenRect].size;
        if ([UIDevice isBelowiOS7])
            self.view.height -= [[UIApplication sharedApplication] statusBarFrame].size.height;
    }
}

@end
