//
//  LTPullToRefreshTableViewController.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EGORefreshTableHeaderView.h"
#import "LTTableView.h"

typedef NSUInteger LTPullToRefreshLoadMoreState;
enum  {
    LTPullToRefreshLoadMoreStateNormal = 0,
    LTPullToRefreshLoadMoreStateLoading,
    LTPullToRefreshLoadMoreStateNoMore,
};

@interface LTPullToRefreshTableViewController : UITableViewController<EGORefreshTableHeaderDelegate, LTTableViewDelegate>


- (id)initWithStyle:(UITableViewStyle)style useLoadMore:(BOOL)loadmore;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useLoadMore:(BOOL)loadmore;

//@property (nonatomic, weak) id<LTPullToRefreshTableViewControllerDelegate> delegate;
@property (nonatomic, getter = isRefreshing) BOOL refreshing;
@property (nonatomic, weak, readonly) EGORefreshTableHeaderView* refreshView;
@property (nonatomic, weak, readonly) UILabel* loadMoreStopLabel;
@property (nonatomic, copy) NSString* pullToRefreshArrowImage;
@property (nonatomic) BOOL arrowRotationFree;

//@property (nonatomic) LTPullToRefreshLoadMoreState

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view;
- (void)pullToRefreshDidPressLoadMore;
- (void)setLoadmoreState:(LTPullToRefreshLoadMoreState)loadmoreState;

// you must call super's method
- (void)scrollViewDidScroll:(UIScrollView *)scrollView;
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

@end
