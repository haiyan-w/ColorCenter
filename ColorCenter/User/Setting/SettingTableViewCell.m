//
//  SettingTableViewCell.m
//  EnochCar
//
//  Created by 王海燕 on 2021/6/16.
//

#import "SettingTableViewCell.h"

@interface SettingTableViewCell()
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel * titleLab;
@property (strong, nonatomic) IBOutlet UILabel * rightLab;
@property (strong, nonatomic) IBOutlet UILabel * subLab;
@property (strong, nonatomic) IBOutlet UIImageView * nextIcon;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *titleLeadingConstraint;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightLabTrailingConstraint;

@end

@implementation SettingTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setItem:(SettingItem *)item
{
    _item = item;
    
    self.icon.image = [UIImage imageNamed:item.iconName];
    self.titleLab.text = item.titleStr;
    self.rightLab.text = item.rightStr;
    self.subLab.text = item.subTitleStr;
    self.nextIcon.hidden = !item.hasNext;
    
    if (item.iconName.length > 0) {
        self.titleLeadingConstraint.constant = 44;
    }else {
        self.titleLeadingConstraint.constant = 16;
    }
    
    if (item.hasNext) {
        self.rightLabTrailingConstraint.constant = 36;
    }else {
        self.rightLabTrailingConstraint.constant = 16;
    }
    
    [self layoutIfNeeded];
}

@end
