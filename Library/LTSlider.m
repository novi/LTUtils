//
//  LTSlider.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/05/01.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTSlider.h"

@implementation LTSlider

-(CGRect)maximumValueImageRectForBounds:(CGRect)bounds
{
    CGRect r = [super maximumValueImageRectForBounds:bounds];
    r.origin.x -= 7;
    return r;
}

-(CGRect)minimumValueImageRectForBounds:(CGRect)bounds
{
    CGRect r = [super minimumValueImageRectForBounds:bounds];
    r.origin.x += 5;
    return r;
}

@end
