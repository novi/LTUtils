//
//  LTPopoverController.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/02/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LTPopoverController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, strong, readonly) UIViewController* contentViewController;
@property (nonatomic) CGSize popoverSize;
@property (nonatomic, readonly, getter=isPopoverVisible) BOOL popoverVisible;

- (id)initWithContentViewController:(UIViewController*)content;
- (void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated;
- (void)dismissPopoverAnimated:(BOOL)animated;

@end
