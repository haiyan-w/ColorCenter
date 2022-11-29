//
//  BleCollectionCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/17.
//

#import "BleCollectionCell.h"
#import "UIColor+CustomColor.h"
#import "TouchView.h"

@interface BleCollectionCell ()
@property (strong, nonatomic) IBOutlet TouchView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *deviceImg;
@property (strong, nonatomic) IBOutlet UIImageView *selectIcon;
@property (strong, nonatomic) IBOutlet UILabel *nameLab;
@end

@implementation BleCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.bgView.layer.cornerRadius = 8.0;
    self.bgView.layer.borderWidth = 1;
    self.bgView.layer.borderColor = [UIColor bgWhiteColor].CGColor;
    self.bgView.backgroundColor = [UIColor bgWhiteColor];
    self.deviceImg.image = [UIImage imageNamed:@"deviceBig_translucent"];
}

- (void)setName:(NSString *)name
{
    _name = name;
    self.nameLab.text = name;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    self.selectIcon.hidden = !selected;
    if (selected) {
        self.bgView.layer.borderColor = [UIColor tintColor].CGColor;
        self.bgView.backgroundColor = [UIColor lightTintColor];
        self.deviceImg.image = [UIImage imageNamed:@"deviceBig"];
    }else {
        self.bgView.layer.borderColor = [UIColor bgWhiteColor].CGColor;
        self.bgView.backgroundColor = [UIColor bgWhiteColor];
        self.deviceImg.image = [UIImage imageNamed:@"deviceBig_translucent"];
    }
}

@end
