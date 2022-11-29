//
//  PopTableViewCell.m
//  EnochCar
//
//  Created by 王海燕 on 2021/10/22.
//

#import "PopTableViewCell.h"

@interface PopTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation PopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
}

@end
