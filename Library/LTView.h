//
//  LTView.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/31.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTView;
typedef void (^LTViewDrawBlock)(LTView* view, CGRect rect, CGContextRef context);
typedef void (^LTViewRectBlock)(LTView* view, CGRect rect);

@interface LTView : UIView


@property (nonatomic, copy) LTViewDrawBlock drawBlock; // rect= dirty rect
@property (nonatomic, copy) LTViewRectBlock layoutBlock; // rect= self.frame


- (void)setDrawBlock:(LTViewDrawBlock)drawBlock;
- (void)setLayoutBlock:(LTViewRectBlock)layoutBlock;

@end
