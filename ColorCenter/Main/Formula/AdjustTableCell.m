//
//  AdjustTableCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "AdjustTableCell.h"
#import "UIView+Frame.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"

@interface AdjustTableCell ()
@property(nonatomic, readwrite, strong) UILabel * serialNoLab;
@property(nonatomic, readwrite, strong) UIImageView * colorImg;
@property(nonatomic, readwrite, strong) UILabel * nameLab;

@end

@implementation AdjustTableCell

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
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.serialNoLab = [[UILabel alloc] init];
    self.serialNoLab.textColor = [UIColor textColor];
    self.serialNoLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:self.serialNoLab];
    
    self.nameLab = [[UILabel alloc] init];
    self.nameLab.textColor = [UIColor textColor];
    self.nameLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:self.nameLab];
    
    self.colorImg = [[UIImageView alloc] init];
    self.colorImg.layer.cornerRadius = 8.0;
    [self addSubview:self.colorImg];
    
    self.countTF = [[UITextField alloc] init];
    self.countTF.backgroundColor = [UIColor bgWhiteColor];
    self.countTF.layer.cornerRadius = 8.0;
    self.countTF.textColor = [UIColor textColor];
    self.countTF.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.countTF.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.countTF];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.serialNoLab.frame = CGRectMake(24, (self.height - 24)/2, 96, 24);
    self.colorImg.frame = CGRectMake(132, (self.height - 16)/2, 16, 16);
    self.nameLab.frame = CGRectMake(self.colorImg.right, (self.height - 24)/2, self.width - 24 - self.colorImg.right - 80, 24);
    self.countTF.frame = CGRectMake(self.width - 24 - 80, (self.height - 36)/2, 80, 36);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setItem:(FormulaDetail *)item
{
    _item = item;
    
    self.serialNoLab.text = item.goods.serialNo;
    self.nameLab.text = item.goods.name;
    self.countTF.text = [NSString stringWithFormat:@"%@",item.weight?item.weight:@"0"];
}

@end
