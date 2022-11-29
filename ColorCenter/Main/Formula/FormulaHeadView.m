//
//  FormulaHeadView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/16.
//

#import "FormulaHeadView.h"
#import "UIView+Frame.h"
#import "UIColor+CustomColor.h"
#import "GradientView.h"

@interface FormulaHeadView ()
@property(nonatomic, readwrite, strong) UILabel * nameLab;
@property(nonatomic, readwrite, strong) UILabel * brandLab;
@property(nonatomic, readwrite, strong) UILabel * timeLab;
@property(nonatomic, readwrite, strong) GradientView * imgView;
@property(nonatomic, readwrite, strong) UIView * line;
@end

@implementation FormulaHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.nameLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 12, 150, 24)];
    self.nameLab.textColor = [UIColor darkTextColor];
    self.nameLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    [self addSubview:self.nameLab];
    
    self.brandLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 40, 150, 22)];
    self.brandLab.textColor = [UIColor textColor];
    self.brandLab.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    [self addSubview:self.brandLab];
    
    self.timeLab = [[UILabel alloc] initWithFrame:CGRectMake(24, 74, 150, 20)];
    self.timeLab.textColor = [UIColor slightTextColor];
    self.timeLab.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    [self addSubview:self.timeLab];
    
    self.imgView = [[GradientView alloc] initWithFrame:CGRectMake(self.right - 109 -  24, 12, 109, 82)];
    [self addSubview:self.imgView];
    
    self.line = [[UIView alloc] initWithFrame:CGRectMake(16, 117, self.width - 2*16, 0.5)];
    self.line.backgroundColor = [UIColor lineColor];
    [self addSubview:self.line];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.nameLab.frame = CGRectMake(24, 12, 150, 24);
    self.brandLab.frame = CGRectMake(24, 40, 150, 22);
    self.timeLab.frame = CGRectMake(24, 12, 150, 24);
    self.imgView.frame = CGRectMake(24, 12, 150, 24);
    self.line.frame = CGRectMake(16, self.height - 1, self.width - 2*16, 0.5);
}

- (void)setName:(NSString *)name brand:(NSString *)brand  time:(NSString *)time colors:(NSArray *)colors
{
    self.nameLab.text = name;
    self.brandLab.text = brand;
    self.timeLab.text = time;
    [self.imgView setColors:colors];
}

//- (void)setColors:(NSArray *)colors
//{
//    [self.imgView setColors:colors];
//}


@end
