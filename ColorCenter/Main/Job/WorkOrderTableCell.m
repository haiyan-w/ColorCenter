//
//  WorkOrderTableCell.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "WorkOrderTableCell.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "CommonTool.h"

@interface  WorkOrderTableCell ()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * subLab;
@end

@implementation WorkOrderTableCell

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
    
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor bgWhiteColor];
    self.bgView.layer.borderColor = [UIColor borderColor].CGColor;
    self.bgView.layer.borderWidth = 1.0;
    self.bgView.layer.cornerRadius = 12.0;
    self.bgView.userInteractionEnabled = NO;
    [self addSubview:self.bgView];
    
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    [self addSubview:self.titleLab];
    
    self.subLab = [[UILabel alloc] init];
    self.subLab.textColor = [UIColor slightTextColor];
    self.subLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self addSubview:self.subLab];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(0, 0, self.width, self.height - 12);
    self.titleLab.frame = CGRectMake(16, 12, self.width-2*16, 24);
    self.subLab.frame = CGRectMake(16, 40, self.width-2*16, 20);
}

- (void)setWorkOrder:(WorkOrderQuery *)workOrder
{
    self.titleLab.text = [NSString stringWithFormat:@"%@(%@)", workOrder.plateNo, workOrder.serialNo];
    self.subLab.text = workOrder.vehicleSpec;
}

@end
