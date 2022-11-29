//
//  CommonRefreshFooter.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/15.
//

#import "CommonRefreshFooter.h"

@interface CommonRefreshFooter ()
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (assign, nonatomic) UIActivityIndicatorViewStyle activityIndicatorViewStyle;
@end

@implementation CommonRefreshFooter

- (UIActivityIndicatorView *)loadingView
{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:_activityIndicatorViewStyle];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle
{
    _activityIndicatorViewStyle = activityIndicatorViewStyle;
    
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    [self setNeedsLayout];
}
#pragma mark - 重写父类的方法
- (void)prepare
{
    [super prepare];
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 130000
    if (@available(iOS 13.0, *)) {
        _activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
        return;
    }
#endif
        
    _activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

- (void)placeSubviews
{
    [super placeSubviews];
    
    CGFloat centerX = self.mj_w * 0.5;
    CGFloat centerY = self.mj_h * 0.5;
    CGPoint center = CGPointMake(centerX, centerY);
    
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = center;
    }
    
    self.stateLabel.center = center;
}


- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
//        self.stateLabel.hidden = YES;
        if (oldState == MJRefreshStateRefreshing) {
            [UIView animateWithDuration:self.slowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 防止动画结束后，状态已经不是MJRefreshStateIdle
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
            }];
        } else {
            [self.loadingView stopAnimating];
        }
    } else if (state == MJRefreshStatePulling) {
//        self.stateLabel.hidden = YES;
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
    } else if (state == MJRefreshStateRefreshing) {
//        self.stateLabel.hidden = YES;
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
    } else if (state == MJRefreshStateNoMoreData) {
        [self.loadingView stopAnimating];
//        self.stateLabel.hidden = NO;
    }
}



@end
