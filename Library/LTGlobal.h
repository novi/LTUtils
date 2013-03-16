//
//  LTGlobal.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/27.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#if DEBUG
#warning Debug log enabled
    #define LTLogInfo NSLog
    #define LTLogError NSLog 
#else
    #define LTLogInfo(...)  { do {} while (0);}
    #define LTLogError(...)  { do {} while (0);}
#endif

#define LTMethodDebugLog() {LTLogInfo(@"%s,%@", __func__, self);}