//
//  LTPopoverController.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/02/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTPopoverController.h"

@interface LTPopoverController ()
{
    UIViewController* _content;
    UIEdgeInsets _contentInset;
    BOOL _popoverVisible;
    
    // parent state
    __weak UIView* _parentView;
    CGRect _targetRect;
    __weak UIView* _rootView;
    
    __weak UIView* _backgroundView;
    __weak UITapGestureRecognizer* _dismissGesture;
    __weak UIImageView* _arrowImageView;
}

-(UIViewController*)_findRootViewController;
- (void)_dismissAnimated;

@end

@implementation LTPopoverController

@synthesize contentViewController = _content;
@synthesize popoverSize;
@synthesize popoverVisible = _popoverVisible;

- (id)initWithContentViewController:(UIViewController*)content
{
    self = [super init];
    if (self) {
        _content = content;
        self.popoverSize = CGSizeMake(180.0f, 180.0f);
        content.contentSizeForViewInPopover = self.popoverSize;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.autoresizingMask = UIViewAutoresizingNone;
    
    [self.view addSubview:_content.view];
    _content.view.autoresizingMask = UIViewAutoresizingNone;
    
    
    _contentInset = UIEdgeInsetsMake(-18.0f, -18.0f, -18.0f, -18.0f);
    
    [self addChildViewController:_content];
    [[self _findRootViewController] addChildViewController:self];
    
    //self.view.backgroundColor = [UIColor colorWithRed:1 green:0 blue:1 alpha:0.1];
    
    UITapGestureRecognizer* gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(_dismissAnimated)];
    gr.enabled = NO;
    gr.cancelsTouchesInView = NO;
    gr.delaysTouchesBegan = NO;
    gr.delaysTouchesEnded = NO;
    gr.delegate = self;
    [self.view addGestureRecognizer:gr];
    _dismissGesture = gr;
    
    UIImageView* background = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"book_popover_back.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 20, 20, 20)] ];
    //background.backgroundColor = [UIColor blueColor];
    [self.view insertSubview:background belowSubview:_content.view];
    background.layer.shadowOffset = CGSizeMake(0, 1);
    //background.layer.shadowOpacity = 0.75;
    background.layer.shadowRadius = 4.0;
    _backgroundView = background;
    
    UIImageView* arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"book_popover_up.png"]];
    [self.view insertSubview:arrowView aboveSubview:_backgroundView];
    arrowView.contentMode = UIViewContentModeBottom;
    _arrowImageView = arrowView;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _backgroundView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return [_content shouldAutorotateToInterfaceOrientation:interfaceOrientation];
}

#pragma mark - 

-(UIViewController*)_findRootViewController
{
    UIWindow* window = [[UIApplication sharedApplication] keyWindow];
    return window.rootViewController;
}

- (void)_relayoutContentView
{
    CGRect targetRect = [_rootView convertRect:_targetRect fromView:_parentView];
    CGPoint center = CGPointMake(CGRectGetMidX(targetRect), CGRectGetMidY(targetRect));
    
    CGRect bounds = UIEdgeInsetsInsetRect(CGRectMake(0, 0, popoverSize.width, popoverSize.height), _contentInset);
    
    _backgroundView.frame = bounds;
    //_content.view.frame = CGRectMake(0, 0, popoverSize.width, popoverSize.height);
    //_content.view.center = 
    _backgroundView.center = CGPointMake(center.x, center.y + bounds.size.height * 0.5);
    
    // fix bouds
    CGRect f = _backgroundView.frame;
    if (CGRectGetMinX(f) < 5) {
        f.origin.x = 5;
    }
    if (CGRectGetMaxX(f) > self.view.bounds.size.width - 5) {
        f.origin.x = self.view.bounds.size.width - f.size.width - 5;
    }
    
    _arrowImageView.bounds = CGRectMake(0, 0, 36, 17);
    _arrowImageView.frame = CGRectMake(roundf(center.x - _arrowImageView.frame.size.width*0.5), roundf(center.y), _arrowImageView.bounds.size.width, _arrowImageView.bounds.size.height);
    if ([[UIScreen mainScreen] scale] == 1.0) {
        f.origin.y += _arrowImageView.bounds.size.height - 5 - 10;
    } else {
        f.origin.y += _arrowImageView.bounds.size.height - 4 - 11;
        _arrowImageView.frame = CGRectOffset(_arrowImageView.frame, 0, -0.5);
    }
    _backgroundView.frame = CGRectMake(roundf(f.origin.x), roundf(f.origin.y), roundf(f.size.width), roundf(f.size.height));
    _backgroundView.layer.shadowPath = [[UIBezierPath bezierPathWithRoundedRect:_backgroundView.bounds cornerRadius:8.0f] CGPath];
    _content.view.frame = CGRectIntegral(CGRectMake(f.origin.x + (-_contentInset.left), f.origin.y + (-floor(_contentInset.top)), popoverSize.width, popoverSize.height));
}

-(void)presentPopoverFromRect:(CGRect)rect inView:(UIView *)view permittedArrowDirections:(UIPopoverArrowDirection)arrowDirections animated:(BOOL)animated
{
    _popoverVisible = YES;
    self.view.userInteractionEnabled = YES;
    _dismissGesture.enabled = YES;
    _parentView = view;
    _targetRect = rect;
    _rootView = [[self _findRootViewController] view];
    
#warning ￼todo:
    _content.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:243/255.0 blue:225/255.0 alpha:1.0];
    
    
    if (!_parentView) {
        LTLogError(@"%@: has no inView", NSStringFromSelector(_cmd));
        return;
    }
    
    self.view.frame = _rootView.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    [self _relayoutContentView];
    
    [_content willAnimateRotationToInterfaceOrientation:self.interfaceOrientation duration:0.1];
    
    self.popoverSize = _content.contentSizeForViewInPopover;
    
    [self _relayoutContentView];

[_rootView addSubview:self.view];
    if (animated) {
        self.view.alpha = 0.0;
        [UIView animateWithDuration:0.4 animations:^{
            self.view.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    } else {
        self.view.alpha = 1.0;
    }

}

- (void)_dismissAnimated
{
    [self dismissPopoverAnimated:YES];
}

-(void)dismissPopoverAnimated:(BOOL)animated
{
    _dismissGesture.enabled = NO;
    _popoverVisible = NO;
//    [self removeFromParentViewController];
    
    
    if (animated) {
        //_content.view.backgroundColor = [UIColor clearColor];
        [UIView animateWithDuration:0.4 animations:^{
            self.view.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self.view removeFromSuperview];
            _parentView = nil;
        }];
    } else {
        [self.view removeFromSuperview];
        _parentView = nil;
    }
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(_backgroundView.frame, [touch locationInView:self.view])) {
        return NO;
    }
    return YES;
}


-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_parentView) {
        //_content.view.hidden = YES;
        //_backgroundView.hidden = YES;
        self.view.alpha = 0.0;
        //_backgroundView.alpha = 0.0;
    }
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (_parentView) {
        [self _relayoutContentView];
    }
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    if (_parentView) {
        self.view.hidden = NO;
        _backgroundView.layer.shadowOpacity = 0.0;
        //_backgroundView.hidden = NO;
        [UIView animateWithDuration:0.3 animations:^{
            self.view.alpha = 1.0;
            //_backgroundView.alpha = 1.0;
        } completion:^(BOOL finished) {
            
        }];
    }
}



@end
