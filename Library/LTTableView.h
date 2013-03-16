//
//  LTTableView.h
//  YomimonoApp1
//
//  Created by 伊藤 祐輔 on 12/03/29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

@protocol LTTableViewDelegate <UITableViewDelegate>

@optional
- (void)scrollViewDidLayout:(UIScrollView *)scrollView;

@end

@interface LTTableView : UITableView

@property(nonatomic,weak)   id <LTTableViewDelegate>   delegate;

@end
