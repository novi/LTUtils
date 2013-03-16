//
//  LTPullToRefreshTableViewController.m
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/06.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LTPullToRefreshTableViewController.h"

@interface LTPullToRefreshTableViewController ()
{
    __weak EGORefreshTableHeaderView* _refreshView;
    __weak UIView* _loadMoreView;
    __weak UIButton* _loadMoreButton;
    __weak UIActivityIndicatorView* _loadMoreIndicator;
    __weak UILabel* _loadMoreStopLabel;
    BOOL _refreshing;
    BOOL _useLoadMore;
    LTPullToRefreshLoadMoreState _loadMoreState;
}
@end

@implementation LTPullToRefreshTableViewController

@synthesize refreshing = _refreshing;
@synthesize refreshView = _refreshView;
@synthesize loadMoreStopLabel = _loadMoreStopLabel;
//@synthesize loadMoreView = _loadMoreView;
@synthesize pullToRefreshArrowImage;
@synthesize arrowRotationFree;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil useLoadMore:(BOOL)loadmore
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _useLoadMore = loadmore;
    }
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    return [self initWithNibName:nibNameOrNil bundle:nibBundleOrNil useLoadMore:NO];
}

-(id)initWithStyle:(UITableViewStyle)style useLoadMore:(BOOL)loadmore
{
    self = [super initWithStyle:style];
    if (self) {
        _useLoadMore = loadmore;
    }
    return self;
}

-(id)initWithStyle:(UITableViewStyle)style
{
    return [self initWithStyle:style useLoadMore:NO];
}

// not supported yet
-(id)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

#pragma mark -

-(void)setRefreshing:(BOOL)refreshing
{
    _refreshing = refreshing;
    if (!refreshing) {
        [_refreshView egoRefreshScrollViewDataSourceDidFinishedLoading:self.tableView];
    }
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    
    EGORefreshTableHeaderView* refreshView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - self.tableView.bounds.size.height, self.view.frame.size.width, self.tableView.bounds.size.height)
                                                                               arrowImageName:self.pullToRefreshArrowImage ? self.pullToRefreshArrowImage : @"blackArrow" textColor:[UIColor darkGrayColor]];
    refreshView.delegate = self;
    refreshView.backgroundColor = [UIColor clearColor];
    refreshView.rotationFree = self.arrowRotationFree;
    [self.tableView addSubview:refreshView];
    _refreshView = refreshView;
    
    if (_useLoadMore) {
        UIView* loadMore = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 50)];
        loadMore.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        UIButton* moreButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        moreButton.frame = CGRectMake(70, 0, 200, 50);
        [moreButton setTitle:@"Load more..." forState:UIControlStateNormal];
        [moreButton addTarget:self action:@selector(_loadmore:) forControlEvents:UIControlEventTouchUpInside];
        //[loadMore addSubview:moreButton];
        //_loadMoreButton = moreButton;
        UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [indicator sizeToFit];
        indicator.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin;
        indicator.center = CGPointMake(CGRectGetMidX(loadMore.bounds), CGRectGetMidY(loadMore.bounds));
        indicator.frame = CGRectIntegral(indicator.frame);
        [loadMore addSubview:indicator];
        _loadMoreIndicator = indicator;
        //indicator.hidesWhenStopped = NO;
        indicator.hidesWhenStopped = YES;
        UILabel* stopLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, -5, self.view.bounds.size.width, 50)];
        stopLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        stopLabel.backgroundColor = [UIColor clearColor];
        stopLabel.textAlignment = UITextAlignmentCenter;
        stopLabel.baselineAdjustment = UIBaselineAdjustmentNone;
        stopLabel.numberOfLines = 1;
        stopLabel.textColor = [UIColor grayColor];
        stopLabel.font = [UIFont systemFontOfSize:24.0f];
        stopLabel.shadowColor = [UIColor whiteColor];
        stopLabel.shadowOffset = CGSizeMake(0, 1);
        stopLabel.text = @"●";
        [loadMore addSubview:stopLabel];
        _loadMoreStopLabel = stopLabel;
        
        self.tableView.tableFooterView = loadMore;
        _loadMoreView = loadMore;
        [self setLoadmoreState:_loadMoreState];
    }
}

-(void)viewDidUnload
{
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return toInterfaceOrientation == UIInterfaceOrientationPortrait;
}

- (void)_loadmore:(id)sender
{
    [self setLoadmoreState:LTPullToRefreshLoadMoreStateLoading];
    
    [self pullToRefreshDidPressLoadMore];
}

-(void)pullToRefreshDidPressLoadMore
{
    
}

- (void)setLoadmoreState:(LTPullToRefreshLoadMoreState)loadmoreState
{
    _loadMoreState = loadmoreState;
    if (_loadMoreState != LTPullToRefreshLoadMoreStateNoMore) {
        _loadMoreIndicator.hidden = NO;
        _loadMoreButton.hidden = NO;
        _loadMoreStopLabel.hidden = YES;
    } else {
        _loadMoreIndicator.hidden = YES;
        _loadMoreButton.hidden = YES;
        _loadMoreStopLabel.hidden = NO;
    }
    
    if (_loadMoreState == LTPullToRefreshLoadMoreStateLoading) {
        [_loadMoreIndicator startAnimating];
        _loadMoreButton.enabled = NO;
    } else if (_loadMoreState == LTPullToRefreshLoadMoreStateNormal) {
        [_loadMoreIndicator stopAnimating];
        _loadMoreButton.enabled = YES;
    } else if (_loadMoreState == LTPullToRefreshLoadMoreStateNoMore) {
        [_loadMoreIndicator stopAnimating];
    }
}

#pragma mark - ScrollView Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_useLoadMore && _loadMoreState == LTPullToRefreshLoadMoreStateNormal) {
        if (scrollView.contentSize.height < scrollView.contentOffset.y+scrollView.bounds.size.height + 40) {
            [self _loadmore:nil];
        }
    }
	[_refreshView egoRefreshScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	[_refreshView egoRefreshScrollViewDidEndDragging:scrollView];
}



#pragma mark - EGORefreshTableHeaderDelegate Methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)view
{	
	//[self _refresh:nil];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)view{
	
	return _refreshing; // should return if data source model is reloading
	
}

/*
 - (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView*)view{
 
 return [NSDate date]; // should return date data source was last changed	
 }
 */

@end
