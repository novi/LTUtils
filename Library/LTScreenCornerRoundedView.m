//
//  LTScreenCornerRoundedView.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTScreenCornerRoundedView.h"

@interface LTScreenCornerRoundedView ()
{
    UIViewContentMode _position;
}
@end

@implementation LTScreenCornerRoundedView

- (id)initWithFrame:(CGRect)frame position:(UIViewContentMode)position
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        //self.clearsContextBeforeDrawing = NO;
        _position = position;
        if (position == UIViewContentModeTopRight) {
            self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleBottomMargin;
        } else if (position == UIViewContentModeBottomRight) {
            self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin;
        }
    }
    return self;
}

// Top-Left
- (void)_drawCornerRoundTopLeft:(CGPoint)p radius:(CGFloat)r inContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, p.x, p.y);
	CGContextAddLineToPoint(context, p.x, p.y+r);
	CGContextAddArcToPoint(context, p.x, p.y, p.x+r, p.y, r);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)_drawCornerRoundBottomLeft:(CGPoint)p radius:(CGFloat)r inContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, p.x+r, p.y);
	CGContextAddArcToPoint(context, p.x, p.y, p.x, p.y-r, r);
	CGContextAddLineToPoint(context, p.x, p.y);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)_drawCornerRoundTopRight:(CGPoint)p radius:(CGFloat)r inContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, p.x, p.y+r);
	CGContextAddArcToPoint(context, p.x, p.y, p.x-r, p.y, r);
	CGContextAddLineToPoint(context, p.x, p.y);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)_drawCornerRoundBottomRight:(CGPoint)p radius:(CGFloat)r inContext:(CGContextRef)context
{
	CGContextMoveToPoint(context, p.x, p.y-r);
	CGContextAddArcToPoint(context, p.x, p.y, p.x-r, p.y, r);
	CGContextAddLineToPoint(context, p.x, p.y);
	CGContextClosePath(context);
	CGContextFillPath(context);
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] setFill];
    
    if (_position == UIViewContentModeTopRight) {
        [self _drawCornerRoundTopRight:CGPointMake(self.bounds.size.width, 0) radius:5 inContext:context];
    } else if (_position == UIViewContentModeBottomRight) {
        [self _drawCornerRoundBottomRight:CGPointMake(self.bounds.size.width, self.bounds.size.height) radius:5 inContext:context];
    }
}


@end
