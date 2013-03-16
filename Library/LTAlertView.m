//
//  LTAlertView.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTAlertView.h"


@interface LTAlertView () <UIAlertViewDelegate>
{
    NSMutableArray* _buttonCallbacks;
}
@end

@implementation LTAlertView

- (BOOL)hasCancelButton
{
    return (self.cancelButtonIndex == 0);
}

-(id)initWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle
{
    self = [super initWithTitle:title message:message delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    if (self) {
        self.delegate = self;
        _buttonCallbacks = [NSMutableArray array];
        if ([self hasCancelButton]) {
            [self setCancelButtonCallback:^(LTAlertView *alertView, NSInteger index) {  /* nop */ }];
        }
    }
    return self;
}

-(void)addButtonWithTitle:(NSString *)title callback:(LTAlertViewCallback)callback
{
    [self addButtonWithTitle:title];
    if (callback) {
        [_buttonCallbacks addObject:[callback copy]];
    } else {
        [_buttonCallbacks addObject:[NSNull null]];
    }
}

-(void)setCancelButtonCallback:(LTAlertViewCallback)block
{
    if (![self hasCancelButton]) return;
    
    if (_buttonCallbacks.count > 0) {
        [_buttonCallbacks removeObjectAtIndex:0];
    }
    
    [_buttonCallbacks insertObject:[block copy] atIndex:0];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 0) {
        [_buttonCallbacks removeAllObjects];
        return;
    }
    LTAlertViewCallback callback = [_buttonCallbacks objectAtIndex:buttonIndex];
    if ((id)callback != [NSNull null]) {
        callback(self, buttonIndex);
    }
    [_buttonCallbacks removeAllObjects];
}

@end
