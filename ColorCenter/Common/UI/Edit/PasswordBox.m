//
//  PasswordBox.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/5.
//

#import "PasswordBox.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "SingleInputTextField.h"

@interface PasswordBox ()
@property (nonatomic,strong) SingleInputTextField * textField;
@property (nonatomic,strong) UIButton * seeBtn;
@property (nonatomic,assign) BOOL canSee;
@end

@implementation PasswordBox

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self= [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit
{
    self.backgroundColor = [UIColor bgWhiteColor];
    self.layer.borderWidth = 0.0;
    self.layer.borderColor = [UIColor borderColor].CGColor;
    self.layer.cornerRadius = 8;
    [self addSubview:self.textField];
    [self addSubview:self.seeBtn];
    
    self.canSee = NO;
}


-(SingleInputTextField *)textField
{
    if (!_textField) {
        _textField = [[SingleInputTextField alloc] init];
        _textField.font = [UIFont textFont];
        _textField.backgroundColor = [UIColor clearColor];
//        _textField.delegate = self;
        _textField.textColor = [UIColor textColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.tintColor = [UIColor tintColor];
//        [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}


-(UIButton *)seeBtn
{
    if (!_seeBtn) {
        _seeBtn = [[UIButton alloc] init];
        _seeBtn.backgroundColor = [UIColor clearColor];
        [_seeBtn addTarget:self action:@selector(seeBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_seeBtn setImage:[UIImage  imageNamed:@"pwd_see"] forState:UIControlStateNormal];
    }
    return _seeBtn;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 12;
    
    self.seeBtn.frame = CGRectMake(self.bounds.size.width - 40, 0, 40, self.bounds.size.height);
    self.textField.frame = CGRectMake(space, 0, self.seeBtn.frame.origin.x - 2*space , self.frame.size.height);
}

-(void)setText:(NSString*)text
{
    self.textField.text = text;
}

-(NSString*)getText
{
    return (self.textField.text)?(self.textField.text):@"";
}

-(void)setPlaceHolder:(NSString * _Nullable)placeHolder
{
    if (self.textField) {
        self.textField.placeholder = placeHolder;
    }
}


-(void)setCanSee:(BOOL)canSee
{
    _canSee = canSee;
    
    if (!canSee) {
        [self.seeBtn setImage:[UIImage  imageNamed:@"pwd_hide"] forState:UIControlStateNormal];
        self.textField.secureTextEntry = YES;
    }else {
        [self.seeBtn setImage:[UIImage  imageNamed:@"pwd_see"] forState:UIControlStateNormal];
        self.textField.secureTextEntry = NO;
    }
}

-(void)seeBtnClick
{
    self.canSee = !self.canSee;
}


@end
