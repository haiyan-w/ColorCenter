//
//  MemberTableViewCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "MemberTableViewCell.h"
#import "UIColor+CustomColor.h"

@interface MemberTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *headImg;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@property (strong, nonatomic) IBOutlet UILabel *phoneLab;
@property (strong, nonatomic) IBOutlet UILabel *statusLab;

@end

@implementation MemberTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.headImg.layer.cornerRadius = 24.0;
    self.headImg.layer.masksToBounds = YES;
    
    self.nameLab.textColor = UIColor.darkTextColor;
    self.phoneLab.textColor = UIColor.slightTextColor;
    self.statusLab.textColor = UIColor.customRedColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
