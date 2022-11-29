//
//  CommonSearchText.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/24.
//

#import "CommonSearchText.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "UIFont+CustomFont.h"

@interface CommonSearchText ()
@property (strong, nonatomic) UIImageView * icon;
@end

@implementation CommonSearchText

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
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 18;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor borderColor].CGColor;
    
    self.icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 20, 20)];
    self.icon.image = [UIImage imageNamed:@"search"];
    [self addSubview:self.icon];
    
    self.textField = [[UITextField alloc] init];
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.textField.returnKeyType = UIReturnKeySearch;
    [self addSubview:self.textField];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    self.icon.frame = CGRectMake(16, (self.bounds.size.height - 20)/2, 20, 20);
    self.textField.frame = CGRectMake(44, 2, self.bounds.size.width - 44 - 16, self.bounds.size.height - 2*2);
}

- (void)setDelegate:(id<UITextFieldDelegate>)delegate
{
    self.textField.delegate = delegate;
}

- (void)setPlaceHolder:(NSString *)placeHolder
{
    self.textField.placeholder = placeHolder;
}


@end
