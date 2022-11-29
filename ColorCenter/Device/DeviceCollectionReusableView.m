//
//  DeviceCollectionReusableView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import "DeviceCollectionReusableView.h"
#import "UIColor+CustomColor.h"

@interface DeviceCollectionReusableView ()
@property (strong, nonatomic) UILabel * label;
@end

@implementation DeviceCollectionReusableView

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    
    return self;
}

- (void)viewInit
{
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor darkTextColor];
    self.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self addSubview:self.label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(8, 0, self.frame.size.width-2*8, self.frame.size.height);

}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = title;
}

@end
