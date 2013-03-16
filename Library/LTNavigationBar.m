//
//  LTNavigationBar.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTNavigationBar.h"

@implementation LTNavigationBar

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.layer.shadowOpacity > 0.0) {
        self.layer.shadowPath = [[UIBezierPath bezierPathWithRect:self.bounds] CGPath];
    }
}

@end

@implementation UINavigationController (LTNavigationBar)

+ (id)lt_navigationControllerUsingLTNavigationBarWithRootViewController:(UIViewController*)vc
{
    UINib* nib = [UINib nibWithNibName:@"LTNavigationControllerLTBar" bundle:nil];
    UINavigationController* navc = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    if (vc) {
        [navc pushViewController:vc animated:NO];
    }
    return navc;
}

@end

