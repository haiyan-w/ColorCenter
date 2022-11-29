//
//  BleTableViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
//

#import "BleTableViewCell.h"
#import "UIView+Frame.h"

@interface BleTableViewCell ()

@end

@implementation BleTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor lightTextColor];
    self.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.label.frame = CGRectMake(48, (self.width-24)/2, self.width-2*48, 24);
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



@end
