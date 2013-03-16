//
//  LTActionSheet.m
//  LTUtils
//
//  Created by ito on 2012/08/07.
//
//

#import "LTActionSheet.h"

@interface LTActionSheet () <UIActionSheetDelegate>
{
    NSMutableArray* _callbacks;
    LTActionSheetCallback _dismissCallback;
}
@end

@implementation LTActionSheet

-(void)setDismissCallback:(LTActionSheetCallback )callback
{
    _dismissCallback = [callback copy];
}

- (void)destroyCallbacks
{
    [_callbacks removeAllObjects];
    [self setDismissCallback:nil];
}


-(id)initWithTitle:(NSString *)title
{
    self = [super initWithTitle:title delegate:nil cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil, nil];
    if (self) {
        self.delegate = self;
        _callbacks = [NSMutableArray array];
    }
    return self;
}

- (void)addCancelButtonWithTitle:(NSString *)title callback:(LTActionSheetCallback)callback
{
    [self addButtonWithTitle:title callback:callback];
    self.cancelButtonIndex = _callbacks.count-1;
}

- (void)addDestructiveButtonWithTitle:(NSString *)title callback:(LTActionSheetCallback)callback
{
    [self addButtonWithTitle:title callback:callback];
    self.destructiveButtonIndex = _callbacks.count-1;
}

- (void)addButtonWithTitle:(NSString*)title callback:(LTActionSheetCallback)callback
{    
    [self addButtonWithTitle:title];
    if (callback) {
        [_callbacks addObject:[callback copy]];
    } else {
        [_callbacks addObject:[NSNull null]];
    }
}

#pragma mark - UIActionSheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex < 0) {
        if (_dismissCallback) {
            _dismissCallback(self, buttonIndex);
        }
        [self destroyCallbacks];
        return;
    }
    
    LTActionSheetCallback callback = [_callbacks objectAtIndex:buttonIndex];
    if (![callback isMemberOfClass:[NSNull class]]) {
        if (callback) {
            callback(self, buttonIndex);
        }
    }
    
    [self destroyCallbacks];
}

@end
