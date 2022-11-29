//
//  CommonTabItemView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/4/24.
//

#import "CommonTabItemView.h"

@implementation CommonTabItemView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initView];
    }
    return self;
}
- (void)initView{
    
    self.imageView = [[UIImageView alloc] init];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.imageView];
    
    self.label = [[UILabel alloc]init];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    self.label.textAlignment = NSTextAlignmentCenter;

    self.button = [[UIButton alloc] init];
    self.button.backgroundColor = [UIColor clearColor];
    [self addSubview:self.button];
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.label.frame = CGRectMake(0, self.topPadding, self.bounds.size.width, self.bounds.size.height - self.topPadding);
    self.imageView.frame = self.label.frame;
    
    self.button.frame = self.bounds;
}

-(void)setBadge:(BadgeView *)badge
{
    if (_badge) {
        [_badge removeFromSuperview];
    }
    
    _badge = badge;
    
    [self insertSubview:_badge belowSubview:self.button];
}

-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    self.button.tag = self.tag;
    [self.button addTarget:target action:action forControlEvents:controlEvents];
}


@end
