//
//  LTNavigationBar.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface LTNavigationBar : UINavigationBar

@end

@interface UINavigationController (LTNavigationBar)

+ (id)lt_navigationControllerUsingLTNavigationBarWithRootViewController:(UIViewController*)vc;

@end
