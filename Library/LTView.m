//
//  LTView.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTView.h"

@implementation LTView

@synthesize drawBlock;
@synthesize layoutBlock;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(BOOL)respondsToSelector:(SEL)aSelector
{
    return [super respondsToSelector:aSelector];
}

-(void)layoutSubviews
{
    if (self.layoutBlock) {
        self.layoutBlock(self, self.frame);
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    if (self.drawBlock) {
        self.drawBlock(self, rect, UIGraphicsGetCurrentContext());
    }
}


@end
