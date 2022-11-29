//
//  LoadTableView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/15.
//

#import "LoadTableView.h"
#import "CommonRefreshHeader.h"
#import "CommonRefreshFooter.h"


@interface LoadTableView ()
@property(nonatomic,readwrite,assign)BOOL hasLoadCurPage;
@property(nonatomic,readwrite,assign)BOOL hasAddObserver;
@end

@implementation LoadTableView

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}


-(void)viewInit
{
    CommonRefreshHeader *header = [CommonRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    header.stateLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    [header setTitle:@"" forState:MJRefreshStateIdle];
    [header setTitle:@"" forState:MJRefreshStatePulling];
    [header setTitle:@"" forState:MJRefreshStateRefreshing];

    //隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    self.mj_header = header;
    //自动切换背景颜色
    self.mj_header.automaticallyChangeAlpha = YES;
    //开始刷新
    [self.mj_header beginRefreshing];

    CommonRefreshFooter * footer  = [CommonRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRefresh)];
    footer.stateLabel.textColor = [UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1];
    footer.stateLabel.font = [UIFont systemFontOfSize:14];

    [footer setTitle:@"" forState:MJRefreshStateIdle];
    [footer setTitle:@"" forState:MJRefreshStatePulling];
    [footer setTitle:@"" forState:MJRefreshStateRefreshing];
    [footer setTitle:@"没有更多数据了" forState:MJRefreshStateNoMoreData];

    self.mj_footer = footer;
    self.mj_footer.automaticallyChangeAlpha = YES;

}


-(void)footerRefresh
{
    //啥也不干
    if (self.hasLoadCurPage) {
        [self.mj_footer endRefreshing];
    }
}


-(void)setPageIndex:(NSInteger)pageIndex
{
    _pageIndex = pageIndex;
}

-(void)setPageCount:(NSInteger)pageCount
{
    _pageCount = pageCount;
}

-(void)refresh
{
    [self.mj_header beginRefreshing];
}

-(void)endRefresh
{
    if (self.mj_header.isRefreshing) {
        [self.mj_header endRefreshing];
    }
}

-(void)loadData
{
    self.pageIndex = 0;
    self.pageCount = 0;
    self.mj_footer.state = MJRefreshStateIdle;
    if (self.refreshBlock) {
        self.isLoading = YES;
        self.refreshBlock();
    }
}

-(void)refreshSuccess
{
    self.emptyStyle = EmptyStyle_NoContent;
    [self reloadData];
    [self endRefresh];
    self.isLoading = NO;
}

-(void)refreshFailureWith:(NSString *)errorMsg
{
    self.errorMsg = errorMsg;
    self.emptyStyle = EmptyStyle_Error;
    [self reloadData];
    [self endRefresh];
    self.isLoading = NO;
}

-(void)loadMore
{
    if (0 == self.pageCount) {
        [self.mj_footer endRefreshing];
    }else if (self.pageIndex >= self.pageCount) {
        [self.mj_footer endRefreshingWithNoMoreData];
    }else {
        if (self.loadMoreBlock && !self.isLoading) {
            self.isLoading = YES;
            self.loadMoreBlock();
        }
    }
}

-(void)loadMoreSuccess
{
    [self reloadData];
    [self endLoadMore];
    self.isLoading = NO;
}

-(void)loadMoreFailure
{
    [self endLoadMore];
    self.isLoading = NO;
}


-(void)endLoadMore
{
    [self.mj_footer endRefreshing];
}

-(void)endWithNoMoreData
{
    [self.mj_footer endRefreshingWithNoMoreData];
}

//-(void)reloadData
//{
//    [self.emptyView removeFromSuperview];
//    self.emptyView = nil;
//    [super reloadData];
//    [self fillEmptyView];
//}
//
//-(void)fillEmptyView {
//
//    NSInteger sections = 1;
//    NSInteger rows = 0;
//
//    id <UITableViewDataSource> dataSource = self.dataSource;
//
//    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
//        sections = [dataSource numberOfSectionsInTableView:self];
//    }
//
//    if ([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
//        for (int i=0; i<sections; i++) {
//            rows += [dataSource tableView:self numberOfRowsInSection:i];
//        }
//    }
//
//    if (rows == 0) {
//        if (![self.subviews containsObject:self.emptyView]) {
//
//            CGRect frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
//            __weak typeof(self) weakSelf = self;
//            switch (self.emptyStyle) {
//                case EmptyStyle_NoContent:
//                {
//                    self.emptyView = [[EmptyView alloc] initWithFrame:frame image:self.emptyImgName text:self.emptyText linkText:self.emptyLinkText linkOperation:^{
//                        __strong typeof(self) strongSelf = weakSelf;
//                        if (strongSelf.linkBlock) {
//                            strongSelf.linkBlock();
//                        }
//                    }];
//                }
//                    break;
//                case EmptyStyle_Error:
//                {
//                    self.emptyView = [[EmptyView alloc] initWithFrame:frame image:@"default_netOff" text:self.errorMsg linkText:self.emptyLinkText?self.emptyLinkText:@"点击重试" linkOperation:^{
//                        __strong typeof(self) strongSelf = weakSelf;
//                        [strongSelf refresh];
//                    }];
//                }
//                    break;
//                default:
//                    break;
//            }
//
//            if (self.coverViewBgColor) {
//                self.emptyView.backgroundColor = self.coverViewBgColor;
//            }
//
//            [self addSubview:self.emptyView];
//        }
//    }
//    else{
//
//        [self.emptyView removeFromSuperview];
//    }
//}


-(void)setContentOffset:(CGPoint)contentOffset
{
    [super setContentOffset:contentOffset];
    
    [self scrollViewContentOffsetDidChange:contentOffset];
}

#pragma mark scroll

- (void)scrollViewContentOffsetDidChange:(CGPoint )contentOffset
{
    CGFloat currentOffsetY = contentOffset.y;
    /*self.refreshControl.isRefreshing == NO加这个条件是为了防止下面的情况发生：
    每次进入UITableView，表格都会沉降一段距离，这个时候就会导致currentOffsetY + scrollView.frame.size.height   > scrollView.contentSize.height 被触发，从而触发loadMore方法，而不会触发refresh方法。
     */
    
    if (!self.isLoading) {
        if ( (currentOffsetY + self.frame.size.height  > self.contentSize.height - 80)&&!self.hasLoadCurPage)
        {
            self.hasLoadCurPage = YES;
            [self loadMore];
        }else {
            self.hasLoadCurPage = NO;
        }
            
    }
}


@end
