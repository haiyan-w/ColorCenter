//
//  LoadTableView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/15.
//

#import "CommonTableView.h"


NS_ASSUME_NONNULL_BEGIN

@interface LoadTableView : CommonTableView
@property(nonatomic,copy) void(^loadMoreBlock)(void);

@property(nonatomic,readwrite,assign) NSInteger pageIndex;//当前加载页
@property(nonatomic,readwrite,assign) NSInteger pageCount;//数据总页数

@property(nonatomic,readwrite,assign)BOOL isLoading;

-(void)refresh;
-(void)refreshSuccess;
-(void)refreshFailureWith:(NSString *)errorMsg;

-(void)loadMore;
-(void)loadMoreSuccess;
-(void)loadMoreFailure;

-(void)endRefresh;
-(void)endLoadMore;
-(void)endWithNoMoreData;
@end

NS_ASSUME_NONNULL_END
