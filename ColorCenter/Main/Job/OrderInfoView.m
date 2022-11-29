//
//  OrderInfoView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/15.
//

#import "OrderInfoView.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "CommonButton.h"

@interface  OrderInfoView ()
@property (strong, nonatomic) CommonButton * btn;
@property (strong, nonatomic) UILabel * label;
@property (strong, nonatomic) UILabel * subLab;
@property (strong, nonatomic) UILabel * noContentLab;
@end

@implementation OrderInfoView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor bgWhiteColor];
        self.layer.cornerRadius = 8.0;
        
        self.btn = [[CommonButton alloc] init];
        [self.btn setTitle:@"选择工单" forState:UIControlStateNormal];
        self.btn.titleLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self.btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
        self.btn.layer.cornerRadius = 12.0;
        [self addSubview:self.btn];
        
        self.noContentLab = [[UILabel alloc] init];
        self.noContentLab.text = @"暂无关联的喷涂工单";
        self.noContentLab.textColor = [UIColor textColor];
        self.noContentLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [self addSubview:self.noContentLab];
        
        self.label = [[UILabel alloc] init];
        self.label.textColor = [UIColor darkTextColor];
        self.label.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        [self addSubview:self.label];
        
        self.subLab = [[UILabel alloc] init];
        self.subLab.textColor = [UIColor slightTextColor];
        self.subLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
        [self addSubview:self.subLab];
        
        self.label.hidden = YES;
        self.subLab.hidden = YES;
        
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.btn.frame = CGRectMake(self.width - 12 - 60, 12, 60, 24);
    self.noContentLab.frame = CGRectMake(16, 12, self.btn.left - 16 - 12, 24);
    self.label.frame = self.noContentLab.frame;
    self.subLab.frame = CGRectMake(16, 40, self.btn.left - 16 - 12, 20);
}

- (void)setWorkOrder:(WorkOrderQuery *)workOrder
{
    if (workOrder) {
        [self.btn setTitle:@"切换工单" forState:UIControlStateNormal];
        self.label.text = [NSString stringWithFormat:@"%@(%@)", workOrder.plateNo, workOrder.serialNo];
        self.subLab.text = workOrder.vehicleSpec;
        
        self.label.hidden = NO;
        self.subLab.hidden = NO;
        self.noContentLab.hidden = YES;
    }else {
        [self.btn setTitle:@"选择工单" forState:UIControlStateNormal];
        self.label.text = @"";
        self.subLab.text = @"";
        self.label.hidden = YES;
        self.subLab.hidden = YES;
        self.noContentLab.hidden = NO;
    }
    
}

- (void)btnClicked
{
    if (self.operateBlk) {
        self.operateBlk();
    }    
}

@end
