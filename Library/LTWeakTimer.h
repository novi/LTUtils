//
//  LTWeakTimer.h
//  LTUtils
//
//  Created by ito on 2012/12/10.
//
//

#import <Foundation/Foundation.h>

@interface LTWeakTimer : NSObject

- (id)initWithRepeatTimeInterval:(NSTimeInterval)ti target:(id)target selector:(SEL)sel userInfo:(id)ui tag:(NSUInteger)tag;

- (id)initWithTarget:(id)target selector:(SEL)sel userInfo:(id)ui tag:(NSUInteger)tag;
- (void)invokeAfterDelay:(NSTimeInterval)ti;

- (void)invalidate;

@property (nonatomic, readonly) id userInfo;
@property (nonatomic, readonly) NSUInteger tag;

@end
