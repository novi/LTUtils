//
//  LTTableView.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTTableView.h"

@implementation LTTableView


@dynamic delegate;

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if ([self.delegate respondsToSelector:@selector(scrollViewDidLayout:)]) {
        [self.delegate scrollViewDidLayout:self];
    }
}

@end
