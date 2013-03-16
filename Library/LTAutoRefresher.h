//
//  LTAutoRefresher.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/02/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTAutoRefresher : NSObject


+ (LTAutoRefresher*)sharedInstance;

@property (atomic) NSUInteger refreshDistance; // defaults to 5 secs

// -----

- (void)addTimerWithKey:(NSString*)key interval:(NSUInteger)sec;
- (void)removeTimerForKey:(NSString*)key; // remove and stop timer
- (void)updateLastRefreshDate:(NSDate*)date forKey:(NSString*)key; // nil date is clear

- (BOOL)isTimerExpiresForKey:(NSString*)key;

- (void)syncRefreshDate; // save last refresh date to persistence
- (void)clearAllTimersAndRefreshDate; // clear stored last refresh date and clear and start all timers

- (void)startTimerForKey:(NSString*)key;
- (void)startTimers; // (re) create timers and expire timer immediately invoked
- (void)clearAllTimers;

// -----

- (void)removeObserver:(id)observer;
- (void)addObserver:(id)observer selector:(SEL)selector forKey:(NSString*)key;

@end

