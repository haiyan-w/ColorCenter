//
//  FormulaTableViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/1.
//

#import "FormulaTableViewCell.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "GradientView.h"

@interface FormulaTableViewCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *brandLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;
@property (strong, nonatomic) IBOutlet GradientView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;
@property (strong, nonatomic) IBOutlet UILabel *typeLab;
@property (strong, nonatomic) IBOutlet UILabel *matchCountLab;

@end

@implementation FormulaTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.bgView.layer.cornerRadius = 8.0;
    self.statusLab.layer.cornerRadius = 8.0;
    self.statusLab.layer.borderWidth = 1.0;
    self.imgView.layer.cornerRadius = 8.0;
    self.imgView.layer.borderColor = [UIColor borderColor].CGColor;
    self.imgView.layer.borderWidth = 1.0;
    self.typeLab.layer.cornerRadius = 12.0;
    self.matchCountLab.layer.cornerRadius = 8.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setJob:(JobQuery *)job
{
    _job = job;
    
    self.nameLab.text = [NSString stringWithFormat:@"%@/%@",job.colorName,job.colorCode];
    self.brandLab.text = job.vehicleSpec;
    self.timeLab.text = job.preparedDatetime;
    self.matchCountLab.text = [NSString stringWithFormat:@"%@个匹配",job.formulaCount];
    
    if ([job isFinished]) {
        self.statusLab.layer.borderColor = [UIColor tintColor].CGColor;
        self.statusLab.textColor = [UIColor tintColor];
    }else {
        self.statusLab.layer.borderColor = [UIColor customRedColor].CGColor;
        self.statusLab.textColor = [UIColor customRedColor];
    }
    
    
    if (job.angle15) {
        [self.imgView setColors:@[[UIColor colorWithRed:job.angle15.rgbR.intValue/255.0 green:job.angle15.rgbG.intValue/255.0 blue:job.angle15.rgbB.intValue/255.0 alpha:1],
                                  [UIColor colorWithRed:job.angle45.rgbR.intValue/255.0 green:job.angle45.rgbG.intValue/255.0 blue:job.angle45.rgbB.intValue/255.0 alpha:1],
                                  [UIColor colorWithRed:job.angle110.rgbR.intValue/255.0 green:job.angle110.rgbG.intValue/255.0 blue:job.angle110.rgbB.intValue/255.0 alpha:1]]];
    }
    
    
}

@end
