//
//  ColorMasterTableCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "ColorMasterTableCell.h"
#import "UIView+Frame.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"

@interface ColorMasterTableCell ()
@property(nonatomic, readwrite, strong) UILabel * serialNoLab;
@property(nonatomic, readwrite, strong) UILabel * nameLab;
@end

@implementation ColorMasterTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.serialNoLab = [[UILabel alloc] init];
    self.serialNoLab.textColor = [UIColor darkTextColor];
    self.serialNoLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self addSubview:self.serialNoLab];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.textColor = [UIColor darkTextColor];
    self.nameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self addSubview:self.nameLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.serialNoLab.frame = CGRectMake(24, (self.height - 24)/2, 96, 24);
    self.nameLab.frame = CGRectMake(132, (self.height - 24)/2, self.width - 24 - 132, 24);
}

- (void)setGoods:(Goods *)goods
{
    self.serialNoLab.text = goods.serialNo;
    self.nameLab.text = goods.name;
}

@end
