//
//  FormulaDetailBaseCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "FormulaDetailBaseCell.h"

@interface FormulaDetailBaseCell ()
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *subLab;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UILabel *timeLab;

@property (strong, nonatomic) IBOutlet UIButton *topBtn;
@property (strong, nonatomic) IBOutlet UIButton *bottomBtn;

@end


@implementation FormulaDetailBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.topBtn.layer.cornerRadius = 12.0;
    self.imgView.layer.cornerRadius = 8.0;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    
    
}

@end
