//
//  MultipleSelectTableViewCell.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/11.
//

#import "MultipleSelectTableViewCell.h"
#import "UIColor+CustomColor.h"



@implementation SelectItem


@end



@interface MultipleSelectTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *label;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIButton *button;

@property (strong, nonatomic) SelectItem * item;
@end



@implementation MultipleSelectTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configData:(SelectItem *)item
{
    self.item = item;
    
    self.label.text = item.text;
    self.button.enabled = !item.disabled;

    if (item.disabled) {
        self.label.textColor = [UIColor lightTextColor];
        if (item.select) {
            self.icon.image = [UIImage imageNamed:@"icon_selectDisable"];
        }else {
            self.icon.image = [UIImage imageNamed:@"icon_unselect"];
        }
    }else {
        self.label.textColor = [UIColor darkTextColor];
        if (item.select) {
            self.icon.image = [UIImage imageNamed:@"icon_select"];
        }else {
            self.icon.image = [UIImage imageNamed:@"icon_unselect"];
        }
    }
    
}


- (IBAction)btnClicked:(id)sender {
    
    self.item.select = !self.item.select;
    [self configData:self.item];
    
}


@end
