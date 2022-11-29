//
//  SearchTableViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "SearchTableViewCell.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"


@interface SearchTableViewCell ()
@property (nonatomic, strong) UIView * bgView;
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UILabel * subLab;
@end

@implementation SearchTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(nullable NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
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

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.backgroundColor = [UIColor clearColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.userInteractionEnabled = NO;
    [self addSubview:self.bgView];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self addSubview:self.titleLab];
    
    self.subLab = [[UILabel alloc] init];
    self.subLab.textColor = [UIColor textColor];
    self.subLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:self.subLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height - 12);
    self.titleLab.frame = CGRectMake(16, 12, self.width - 2*16, 24);
    self.subLab.frame = CGRectMake(self.titleLab.left, self.titleLab.bottom + 4, self.titleLab.width, 22);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self.titleLab.text = title;
    self.subLab.text = subTitle;
}

@end
