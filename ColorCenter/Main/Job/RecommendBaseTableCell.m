//
//  RecommendBaseTableCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "RecommendBaseTableCell.h"
#import "GradientView.h"

@interface RecommendBaseTableCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *brandLab;

@property (strong, nonatomic) IBOutlet GradientView *imgView;
@property (strong, nonatomic) IBOutlet UIView *line;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;

@end

@implementation RecommendBaseTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.imgView.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFormula:(JobFormulaQuery *)formula
{
    _formula = formula;
    
    [self layoutSubviews];
    
    self.line.hidden = YES;
    
    self.nameLab.text = formula.colorName;
    self.brandLab.text = formula.vehicleSpec;
    if (self.brandLab.text.length == 0) {
        self.brandLab.text = @"暂无车辆信息";
    }
    self.timeLab.text = [NSString stringWithFormat:@"%@",formula.year];
    
    NSArray * colors = @[(__bridge id)[UIColor colorWithRed:formula.angle15.rgbR.intValue/255.0 green:formula.angle15.rgbG.intValue/255.0 blue:formula.angle15.rgbB.intValue/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:formula.angle45.rgbR.intValue/255.0 green:formula.angle45.rgbG.intValue/255.0 blue:formula.angle45.rgbB.intValue/255.0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:formula.angle110.rgbR.intValue/255.0 green:formula.angle110.rgbG.intValue/255.0 blue:formula.angle110.rgbB.intValue/255.0 alpha:1].CGColor];
    
    [self.imgView setColors:colors];

}

@end
