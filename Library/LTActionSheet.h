//
//  LTActionSheet.h
//  LTUtils
//
//  Created by ito on 2012/08/07.
//
//

#import <UIKit/UIKit.h>

@class LTActionSheet;

typedef void (^LTActionSheetCallback)(LTActionSheet *actionsheet, NSInteger index);

@interface LTActionSheet : UIActionSheet

- (id)initWithTitle:(NSString *)title;
- (void)addCancelButtonWithTitle:(NSString *)title callback:(LTActionSheetCallback)callback;
- (void)addDestructiveButtonWithTitle:(NSString *)title callback:(LTActionSheetCallback)callback;
- (void)addButtonWithTitle:(NSString*)title callback:(LTActionSheetCallback)callback;
- (void)setDismissCallback:(LTActionSheetCallback)callback; // (for iPad, Popover)

@end
