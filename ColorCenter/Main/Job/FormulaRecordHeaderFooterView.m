//
//  FormulaRecordHeaderFooterView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/2.
//

#import "FormulaRecordHeaderFooterView.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"

@interface  FormulaRecordHeaderFooterView ()
@property (strong, nonatomic) UIView * bgView;
@property (strong, nonatomic) UIView * point;
@property (strong, nonatomic) UIView * lineV;
@property (strong, nonatomic) UILabel * titleLab;
@property (strong, nonatomic) UILabel * timeLab;
@end

@implementation FormulaRecordHeaderFooterView


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
    self.backgroundColor = [UIColor whiteColor];
    self.bgView = [[UIView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    
    self.point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 4, 4)];
    self.point.layer.cornerRadius = 4.0;
    self.point.backgroundColor = [UIColor tintColor];
    
    self.lineV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 12)];
    self.lineV.backgroundColor = [UIColor tintColor];
    
    self.titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    self.titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.titleLab.textColor = [UIColor darkTextColor];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 22)];
    self.timeLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.timeLab.textColor = [UIColor slightTextColor];
    self.timeLab.textAlignment = NSTextAlignmentRight;
    
    [self addSubview:self.bgView];
    [self addSubview:self.point];
    [self addSubview:self.lineV];
    [self addSubview:self.titleLab];
    [self addSubview:self.timeLab];
}

- (void)layoutSubviews
{
    self.bgView.frame = self.bounds;
    self.point.frame = CGRectMake(24, 20, 8, 8);
    self.titleLab.frame = CGRectMake(56, (self.frame.size.height - 24)/2, 100, 24);
    self.timeLab.frame = CGRectMake(self.frame.size.width - 150 - 24, (self.frame.size.height - 20)/2, 150, 20);
    
    if (!self.isFooter) {
        self.lineV.frame = CGRectMake(27, self.frame.size.height - 12, 2, 12);
    }else {
        self.lineV.frame = CGRectMake(27, 0, 2, 12);
    }
    
}

- (void)setIsFooter:(BOOL)isFooter
{
    _isFooter = isFooter;
    
    if (isFooter) {
        self.titleLab.text = @"上车";
    }else {
        self.titleLab.text = @"原始测色数据";
    }
    
    [self layoutSubviews];
}

- (void)setDisabled:(BOOL)disabled
{
    _disabled = disabled;
    
    if (disabled) {
        self.point.backgroundColor = [UIColor lightTextColor];
        self.titleLab.textColor = [UIColor lightTextColor];
    }else {
        self.point.backgroundColor = [UIColor tintColor];
        self.titleLab.textColor = [UIColor darkTextColor];
    }
}

- (void)setDatetime:(NSString *)datetime
{
    _datetime = datetime;
    self.timeLab.text = datetime;
}

@end
