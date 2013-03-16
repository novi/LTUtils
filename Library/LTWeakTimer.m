//
//  LTWeakTimer.m
//  LTUtils
//
//  Created by ito on 2012/12/10.
//
//

#import "LTWeakTimer.h"

@interface LTWeakTimer ()
{
    BOOL _repeats;
    __weak id _target;
    
    SEL _selector;
    __weak NSTimer* _timer;
}
@end

@implementation LTWeakTimer

-(id)initWithRepeatTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)sel userInfo:(id)ui tag:(NSUInteger)tag
{
    self = [super init];
    if (self) {
        _repeats = YES;
        _target = target;
        _selector = sel;
        _userInfo = ui;
        _tag = tag;
        _timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerinvoker:) userInfo:nil repeats:YES];
    }
    return self;
}

-(id)initWithTarget:(id)target selector:(SEL)sel userInfo:(id)ui tag:(NSUInteger)tag
{
    self = [super init];
    if (self) {
        _target = target;
        _selector = sel;
        _userInfo = ui;
        _tag = tag;
    }
    return self;
}

- (void)timerinvoker:(id)timer
{
    if (!_target) {
        // invalid target
        [_timer invalidate];
        _timer = nil;
    }
    SEL sel = _selector;
    [_target performSelector:sel withObject:self];
}

-(void)invokeAfterDelay:(NSTimeInterval)ti
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:ti target:self selector:@selector(timerinvoker:) userInfo:nil repeats:NO];
}

-(void)invalidate
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}


@end
