//
//  AFormulaTableCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "AFormulaTableCell.h"
#import "UIView+Frame.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"

@interface AFormulaTableCell ()
@property(nonatomic, readwrite, strong) UILabel * serialNoLab;
@property(nonatomic, readwrite, strong) UIImageView * colorImg;
@property(nonatomic, readwrite, strong) UILabel * nameLab;
@property(nonatomic, readwrite, strong) UILabel * countLab;
@end

@implementation AFormulaTableCell

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
    
    self.countLab = [[UILabel alloc] init];
    self.countLab.textColor = [UIColor textColor];
    self.countLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.countLab.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.countLab];
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.serialNoLab.frame = CGRectMake(24, (self.height - 24)/2, 96, 24);
    self.colorImg.frame = CGRectMake(132, (self.height - 16)/2, 16, 16);
    self.nameLab.frame = CGRectMake(self.colorImg.right, (self.height - 24)/2, self.width - 24 - self.colorImg.right - 80, 24);
    self.countLab.frame = CGRectMake(self.width - 24 - 80, (self.height - 24)/2, 80, 24);
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
    self.countLab.text = [NSString stringWithFormat:@"%@g",item.weight];
}


+ (float)heightWithFormulaDetail:(FormulaDetail *)formulaDetail
{
    float height = 48;
    
    //????
    return height;
}

@end
