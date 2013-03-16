//
//  LTAutoRefresher.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/02/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTAutoRefresher.h"

@interface LTAutoRefresherInvoke : NSObject

- (id)initWithTarget:(id)aTarget selector:(SEL)sel;
@property (nonatomic, weak) id target;
@property (nonatomic, assign) SEL selector;

@end

@implementation LTAutoRefresherInvoke

-(id)initWithTarget:(id)aTarget selector:(SEL)sel
{
    self = [super init];
    if (self) {
        self.target = aTarget;
        self.selector = sel;
    }
    return self;
}

@end

@interface LTAutoRefresher ()
{
    NSMutableDictionary* _refreshDate;
    
    NSMutableDictionary* _observers;
    NSMutableDictionary* _timers;
    NSMutableDictionary* _intervals;
    NSDate* _lastScheduledDate;
}
@end

@implementation LTAutoRefresher


+ (id)sharedInstance
{
    static dispatch_once_t pred;
    static id obj = nil;
    
	dispatch_once(&pred, ^{ obj = [[self alloc] init]; });
    return obj;   
}
- (id)init
{
    self = [super init];
    if (self) {
        _observers = [NSMutableDictionary dictionary];
        _timers = [NSMutableDictionary dictionary];
        _intervals = [NSMutableDictionary dictionary];
        //self.refreshDistance = 5;
        _refreshDate = [[[self class] readFromPersistence] mutableCopy];
    }
    return self;
}

- (void)addTimerWithKey:(NSString*)key interval:(NSUInteger)sec
{
    if (sec >= 1) {
         [_intervals setObject:[NSNumber numberWithUnsignedInteger:sec] forKey:key];
    }
}

- (void)removeTimerForKey:(NSString*)key
{
    [_intervals removeObjectForKey:key];
    NSTimer* timer = [_timers objectForKey:key];
    [timer invalidate];
    [_timers removeObjectForKey:key];
}

-(void)updateLastRefreshDate:(NSDate *)date forKey:(NSString *)key
{
    if (date) {
        [_refreshDate setObject:date forKey:key];
    } else {
        [_refreshDate removeObjectForKey:key];
    }
}

-(BOOL)isTimerExpiresForKey:(NSString *)key
{
    NSDate* last = [_refreshDate objectForKey:key];
    if (!last) {
        return YES;
    }
    NSDate* now = [NSDate date];
    NSUInteger interval = [[_intervals objectForKey:key] unsignedIntegerValue];
    if (interval == 0) {
        return NO;
    }
    if (now.timeIntervalSince1970 - last.timeIntervalSince1970 > interval) {
        LTLogInfo(@"expires: %@, last:%@", key, last);
        return YES;
    }
    return NO;
}

- (void)syncRefreshDate
{
    [[self class] storeToPersistence:_refreshDate];
}

-(void)clearAllTimersAndRefreshDate
{
    [[self class] storeToPersistence:nil];
    _refreshDate = [NSMutableDictionary dictionary];
    [self clearAllTimers];
}

- (void)startTimerForKey:(NSString*)key
{
    
    
    NSUInteger interval = [[_intervals objectForKey:key] unsignedIntegerValue];
    if ([self isTimerExpiresForKey:key]) {
        
        NSUInteger distance = 0;
        if (_lastScheduledDate) {
            NSDate* now = [NSDate date];
            if (now.timeIntervalSince1970 - _lastScheduledDate.timeIntervalSince1970 <= self.refreshDistance) {
                // is future
                _lastScheduledDate = [_lastScheduledDate dateByAddingTimeInterval:self.refreshDistance];
                distance = _lastScheduledDate.timeIntervalSinceNow;
            } else {
                _lastScheduledDate = [_lastScheduledDate dateByAddingTimeInterval:self.refreshDistance];
                //distance = _lastScheduledDate.timeIntervalSinceNow;
            }
        } else {
            _lastScheduledDate = [NSDate date];
        }
        
        // invoke immediately
        [_timers setObject:[NSTimer scheduledTimerWithTimeInterval:distance target:self selector:@selector(timerInvoker:) userInfo:key repeats:NO] forKey:key];
        //distance += self.refreshDistance;
    } else {
        [_timers setObject:[NSTimer scheduledTimerWithTimeInterval:interval target:self selector:@selector(timerInvoker:) userInfo:key repeats:NO] forKey:key];
    }
}

-(void)startTimers
{
    [self clearAllTimers];
    
    for (NSString* key in _intervals) {
        [self startTimerForKey:key];
    }
}

-(void)clearAllTimers
{
    _lastScheduledDate = nil;
    [_timers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [(NSTimer*)obj invalidate];
    }];
    
    [_timers removeAllObjects];
}

#pragma mark -

- (void)removeObserver:(id)observer
{
    for (NSString* key in _observers) {
        NSMutableArray* observers = [_observers objectForKey:key];
        for (LTAutoRefresherInvoke* invoke in [observers reverseObjectEnumerator]) {
            if (invoke.target == observer) {
                [observers removeObject:invoke];
            }
        }
    }
}

- (void)addObserver:(id)observer selector:(SEL)selector forKey:(NSString*)key
{
    NSMutableArray* observers = [_observers objectForKey:key];
    if (!observers) {
        observers = [NSMutableArray array];
        [_observers setObject:observers forKey:key];
    }
    [observers addObject:[[LTAutoRefresherInvoke alloc] initWithTarget:observer selector:selector]];
}

- (void)timerInvoker:(NSTimer*)timer
{
    NSArray* observers = [_observers objectForKey:timer.userInfo];
    for (LTAutoRefresherInvoke* invoker in observers) {
        LTLogInfo(@"refresh invoked: %@ (%@)", invoker.target, NSStringFromSelector(invoker.selector));
        SEL sel = invoker.selector;
        id target = invoker.target;
        [target performSelector:sel withObject:timer.userInfo];
    }
    [_refreshDate setObject:[NSDate date] forKey:timer.userInfo];
    [_timers removeObjectForKey:timer.userInfo];
    NSUInteger sec = [[_intervals objectForKey:timer.userInfo] unsignedIntegerValue];
    [_timers setObject:[NSTimer scheduledTimerWithTimeInterval:sec target:self selector:@selector(timerInvoker:) userInfo:timer.userInfo repeats:NO] forKey:timer.userInfo];
}


+ (NSDictionary*)readFromPersistence
{
    NSDictionary* dict = [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"refreshDate"];
    if (dict) {
        return dict;
    }
    return [NSDictionary dictionary];
}

+ (void)storeToPersistence:(NSDictionary*)dict
{
    if (dict) {
        [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"refreshDate"];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"refreshDate"];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
