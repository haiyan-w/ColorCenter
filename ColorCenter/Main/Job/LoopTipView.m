//
//  LoopTipView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
//

#import "LoopTipView.h"
#import "UIView+Frame.h"

@interface  LoopTipView ()
@property (strong, nonatomic) UIImageView * icon;
@property (strong, nonatomic) UIScrollView * scrollView;
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UILabel * nextLab;
@property (strong, nonatomic) NSTimer * timer;
@end

@implementation LoopTipView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor colorWithRed:254/255.0 green:243/255.0 blue:230/255.0 alpha:1];
        self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tip"]];
        [self addSubview:self.icon];
        
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.scrollEnabled = NO;
        self.scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:self.scrollView];
        
        self.label = [self textLabel];
        [self.scrollView addSubview:self.label];
        
        self.nextLab = [self textLabel];
        [self.scrollView addSubview:self.nextLab];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(16, (self.height - 16)/2, 16, 16);
    self.scrollView.frame = CGRectMake(40, (self.height - 22)/2, self.width - 40, 22);

    self.label.frame = CGRectMake(0, 0, self.label.width, self.scrollView.height);
    self.nextLab.frame = CGRectMake(self.label.right + 100, 0, self.nextLab.width, self.scrollView.height);
    self.scrollView.contentSize = CGSizeMake(self.nextLab.right, self.scrollView.height);
}

- (void)play
{
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 repeats:YES block:^(NSTimer * _Nonnull timer) {
        __strong typeof(self) strongSelf = weakSelf;
        CGPoint pt = strongSelf.scrollView.contentOffset;
        strongSelf.scrollView.contentOffset  = CGPointMake(pt.x + 0.5, 0);
        
        if (strongSelf.scrollView.contentOffset.x >= strongSelf.nextLab.left) {
            strongSelf.scrollView.contentOffset  = CGPointMake(0, 0);
        }
    }];
    
}


- (UILabel *)textLabel
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = [UIColor colorWithRed:237/255.0 green:123/255.0 blue:47/255.0 alpha:1];
    label.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    label.text = @"提示：完善车辆信息或关联工单能极大提高推荐配方的准确度！";
    [label sizeToFit];
    return label;
}
@end
