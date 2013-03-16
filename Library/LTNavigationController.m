//
//  LTNavigationController.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTNavigationController.h"

@interface LTNavigationController ()
{
    BOOL _disablesAutomaticKeyboardDismissal;
}
@end

@implementation LTNavigationController

@synthesize disablesAutomaticKeyboardDismissal = _disablesAutomaticKeyboardDismissal;

- (id)initWithRootViewController:(UIViewController *)rootViewController
{
    self = [super initWithRootViewController:rootViewController];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationFormSheet;
        self.disablesAutomaticKeyboardDismissal = NO;
    }
    return self;
}

@end
