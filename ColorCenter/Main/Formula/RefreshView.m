//
//  RefreshView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/24.
//

#import "RefreshView.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "UIFont+CustomFont.h"

@interface RefreshView ()
@property (nonatomic, strong) UILabel * label;
@property (nonatomic, strong) UIImageView * icon;
@end

@implementation RefreshView

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
    self.backgroundColor = [UIColor bgWhiteColor];
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor tintColor];
    self.label.font = [UIFont tipFont];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.text = @"上拉查看下个配方";
    [self addSubview:self.label];
    
    self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowup"]];
    [self addSubview:self.icon];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.label sizeToFit];
    float width = self.label.width + 6 + 8;
    if (self.icon.hidden) {
        width = self.label.width;
    }
    self.label.frame = CGRectMake((self.width - width)/2, 0, self.label.width, self.height);
    self.icon.frame = CGRectMake(self.label.right + 6, (self.height - 8)/2, 8, 8);
}

- (void)setEnd:(BOOL)end
{
    _end = end;
    
    if (end) {
        self.label.text = self.endText;
    }else {
        self.label.text = self.normalText;
    }
    
    self.icon.hidden = end;
    [self layoutSubviews];
}

- (void)setIconName:(NSString *)iconName
{
    _iconName = iconName;
    
    self.icon.image = [UIImage imageNamed:iconName];
}
@end
