//
//  LTMasterViewController.h
//  LTUtils
//
//  Created by 伊藤 祐輔 on 12/04/13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LTDetailViewController;

@interface LTMasterViewController : UITableViewController

@property (strong, nonatomic) LTDetailViewController *detailViewController;

@end
