//
//  CommonButton.m
//  EnochCar
//
//  Created by 王海燕 on 2021/9/16.
//

#import "CommonButton.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"

@implementation CommonButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}


-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title
{
    self = [self initWithFrame:frame];
    if (self) {
//        [self viewInit];
        [self setTitle:title forState:UIControlStateNormal];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame normalTitle:(NSString*)normalTitle disabledTitle:(NSString*)disabledTitle
{
    self = [self initWithFrame:frame];
    if (self) {
//        [self viewInit];
        [self setTitle:normalTitle forState:UIControlStateNormal];
        [self setTitle:disabledTitle forState:UIControlStateDisabled];
    }
    return self;
}


-(void)viewInit
{
    self.backgroundColor = [UIColor tintColor];
    self.layer.cornerRadius = 4.0f;
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.titleLabel.font = [UIFont boldTextFont];
}



-(void)setNormalTitle:(NSString*)normalTitle disabledTitle:(NSString*)disabledTitle
{
    [self setTitle:normalTitle forState:UIControlStateNormal];
    [self setTitle:disabledTitle forState:UIControlStateDisabled];
}

-(void)setEnabled:(BOOL)enabled
{
    [super setEnabled:enabled];
   
    if (enabled) {
        self.backgroundColor = [UIColor tintColor];
    }else {
        self.backgroundColor = [UIColor lightTintColor];
    }
}

@end
