//
//  LTAlertView.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/20.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@class LTAlertView;

typedef void (^LTAlertViewCallback)(LTAlertView *alertView, NSInteger index);

@interface LTAlertView : UIAlertView 

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle;

-(void)addButtonWithTitle:(NSString*)title callback:(LTAlertViewCallback)callback;
-(void)setCancelButtonCallback:(LTAlertViewCallback)block;

@end
