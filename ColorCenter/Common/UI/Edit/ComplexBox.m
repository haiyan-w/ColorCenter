//
//  ComplexBox.m
//  EnochCar
//
//  Created by 王海燕 on 2021/7/9.
//

#import "ComplexBox.h"
#import "NetWorkAPIManager.h"
#import "PopViewController.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "LookUp.h"
#import "Hint.h"
#import "UIView+Hint.h"


@interface ComplexBox()<PopViewDelagate,UITextFieldDelegate>
@property (nonatomic,strong) UILabel * titleLab;
@property (nonatomic,strong) UIView * boxView;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic,strong) UILabel * rightLab;
@property (nonatomic,strong) UIButton * rightBtn;
@property (nonatomic,strong) UIImageView * rightImage;
@property (nonatomic,strong) UIButton * selectBtn;
@property (nonatomic,assign) ComplexBoxMode mode;
@property (nonatomic,assign) NSString * title;
@property (nonatomic,strong) NSArray * messages;
@property (nonatomic,strong) id selectedItem;

@end

@implementation ComplexBox


-(instancetype)initWithCoder:(NSCoder *)coder
{
    self= [super initWithCoder:coder];
    if (self) {
        [self addSubview:self.titleLab];
        [self addSubview:self.boxView];
        self.enabled = YES;
        self.queryMode = ComplexBoxQueryNull;        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode
{
    self= [self initWithFrame:frame mode:mode title:nil];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:(NSString * _Nullable)title
{
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.titleLab];
        [self addSubview:self.boxView];
        self.title = title;
        self.titleLab.text = title;
        self.mode = mode;
        self.enabled = YES;
        self.queryMode = ComplexBoxQueryNull;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:(NSString * _Nullable)title hint:(NSString *)hint  popTitle:(NSString *)popTitle
{
    self= [self initWithFrame:frame mode:mode title:title];
    if (self) {
        self.queryMode = ComplexBoxQueryHint;
        self.hint = hint;
        self.popTitle = popTitle;
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame mode:(ComplexBoxMode)mode title:(NSString * _Nullable)title lookup:(NSString *)lookup  popTitle:(NSString *)popTitle
{
    self= [self initWithFrame:frame mode:mode title:title];
    if (self) {
        self.queryMode = ComplexBoxQueryLookup;
        self.lookup = lookup;
        self.popTitle = popTitle;
    }
    return self;
}

- (void)setBoxItem:(ComplexBoxItem * _Nullable)boxItem
{
    _boxItem = boxItem;
    
    self.title = boxItem.title;
    self.popTitle = boxItem.popTitle;
    self.mode = boxItem.mode;
    self.queryMode = boxItem.queryMode;
    self.inputCheckMode = boxItem.inputCheckMode;
    switch (self.queryMode) {
        case ComplexBoxQueryLookup:
        {
            self.lookup = boxItem.queryCode;
        }
            break;
        case ComplexBoxQueryHint:
        {
            self.hint = boxItem.queryCode;
        }
            break;
        default:
            break;
    }
    self.isRequired = boxItem.isRequired;
    self.enabled = boxItem.enabled;
}

-(void)setMode:(ComplexBoxMode)mode
{
    _mode = mode;
    switch (mode) {
        case ComplexBoxEdit:
        {
            [self.boxView addSubview:self.textField];
            [self.boxView addSubview:self.rightLab];
            
            self.textField.placeholder = @"请输入";
        }
            break;
        case ComplexBoxSelect:
        {
            [self.boxView addSubview:self.rightImage];
            [self.boxView addSubview:self.textField];
            [self.boxView addSubview:self.selectBtn];
            
            self.textField.placeholder = @"请选择";
        }
            break;
        case ComplexBoxEditAndSelect:
        {
            [self.boxView addSubview:self.rightImage];
            [self.boxView addSubview:self.selectBtn];
            [self.boxView addSubview:self.textField];
            
            self.textField.placeholder = @"请输入或选择";
            
        }
            break;
            
        default:
            break;
    }

    [self layoutSubviews];
}

-(void)setRightStr:(NSString *)rightStr
{
    self.rightLab.text = rightStr;
    [self.rightLab sizeToFit];
    [self layoutSubviews];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat space = 12;
    CGFloat boxOrgY = 0;
    CGFloat imageW = 20;
    CGFloat imageH = 20;
    
    if (self.title.length > 0) {
        self.titleLab.frame = CGRectMake(space, 0, (self.frame.size.width-2*space), 24);
        boxOrgY = self.titleLab.frame.size.height + 5;
    }else {
        self.titleLab.frame = CGRectMake(0, 0, 0, 0 );
    }
    
    self.boxView.frame = CGRectMake(0, boxOrgY, self.frame.size.width, self.frame.size.height - boxOrgY);
    
    switch (self.mode) {
        case ComplexBoxEdit:
        {
            self.rightLab.frame = CGRectMake((self.boxView.frame.size.width - self.rightLab.frame.size.width - 12), (self.boxView.frame.size.height - self.rightLab.frame.size.height)/2, self.rightLab.frame.size.width, self.rightLab.frame.size.height);
          
            self.textField.frame = CGRectMake(space, 0, self.boxView.frame.size.width - self.rightLab.frame.size.width - 2*space, self.boxView.bounds.size.height);
        }
            break;
        case ComplexBoxSelect:
        {
            self.rightImage.frame = CGRectMake((self.boxView.bounds.size.width - imageW-10), (self.boxView.bounds.size.height - imageH)/2, imageW, imageH);
            self.textField.frame = CGRectMake(space, 0, self.rightImage.frame.origin.x - 2*space , self.boxView.bounds.size.height);
            self.selectBtn.frame = CGRectMake(0, 0, self.boxView.bounds.size.width, self.boxView.bounds.size.height);
        }
            break;
        case ComplexBoxEditAndSelect:
        {
            self.rightImage.frame = CGRectMake((self.boxView.bounds.size.width - imageW-10), (self.boxView.bounds.size.height - imageH)/2, imageW, imageH);
            self.textField.frame = CGRectMake(space, 0, self.rightImage.frame.origin.x - 2*space , self.boxView.frame.size.height);
            self.selectBtn.frame = CGRectMake(self.boxView.bounds.size.width-40, 0, 40, self.boxView.bounds.size.height);
        }
            break;
            
    }
}


-(void)setRightImageName:(NSString *)imageName
{
    [self.rightImage setImage:[UIImage imageNamed:imageName]];
}

-(void)setItem:(id)item
{
    _selectedItem = item;
    self.textField.text = [self getTextFromItem:item];
}

-(id)getSelectedItem
{
    return _selectedItem;
}

-(void)setText:(NSString*)text
{
    self.textField.text = text;
    
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBox:didTextChanged:)]) {
        [self.boxDelegate complexBox:self didTextChanged:self.textField.text];
    }
}

-(NSString*)getText
{
    return (self.textField.text)?(self.textField.text):@"";
}

-(NSString*)getTitle
{
    return self.title;
}

-(void)setFont:(UIFont *)font
{
    self.textField.font = font;
}

-(void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    if (_enabled) {
        if (self.boxBgColor) {
            self.boxView.backgroundColor = self.boxBgColor;
        }else {
            self.boxView.backgroundColor = [UIColor whiteColor];
        }
        
        self.boxView.layer.borderWidth = 1.0;
        self.selectBtn.enabled = YES;
        self.textField.enabled = YES;
        
    }else {
        self.boxView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.boxView.layer.borderWidth = 0;
        self.selectBtn.enabled = NO;
        self.textField.enabled = NO;
    }
}

- (void)setIsRequired:(BOOL)isRequired
{
    _isRequired = isRequired;
    
    [self refreshTitle];
}

-(void)refreshTitle
{
    NSMutableAttributedString * attr  = [[NSMutableAttributedString alloc] init];
    
    if (self.isRequired ) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:@"*" attributes:@{NSFontAttributeName : self.titleLab.font , NSForegroundColorAttributeName : [UIColor customRedColor]}]];
    }
    
    if (self.title.length > 0) {
        [attr appendAttributedString:[[NSAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName:self.titleLab.font, NSForegroundColorAttributeName : [UIColor darkTextColor]}]];
    }
    
    self.titleLab.attributedText = attr;
}

-(void)setBorderColor:(UIColor*)borderColor
{
    _borderColor = borderColor;
    
    self.boxView.layer.borderColor = _borderColor.CGColor;
}

- (void)setBoxBgColor:(UIColor *)boxBgColor
{
    _boxBgColor = boxBgColor;
    
    self.enabled = _enabled;
}

-(void)setKeyboardType:(UIKeyboardType)keyboardType
{
    self.textField.keyboardType = keyboardType;
}

-(UIKeyboardType)keyboardType
{
    return self.textField.keyboardType;
}

-(void)setDelegate:(id)delegate
{
    _delegate = delegate;
    self.textField.delegate = delegate; 
}

-(void)setPlaceHolder:(NSString * _Nullable)placeHolder
{
    if (self.textField) {
        self.textField.placeholder = placeHolder;
    }
}


-(void)setTag:(NSInteger)tag
{
    [super setTag:tag];
    self.textField.tag = tag;
}

-(void)selectBtnClick:(id)sender
{
    [CommonTool resign];
    
    if (self.selectBlock) {
        self.selectBlock();
        return;
    }
    
    if (!self.messages) {
        [self queryMessages];
    }else {
        [self showPopView];
    }
}

- (void)addTarget:(nullable id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.textField addTarget:target action:action forControlEvents:controlEvents];
}

-(void)queryMessages
{
    __weak typeof(self) weakSelf = self;
    if (self.queryMode == ComplexBoxQueryLookup) {
        NSString * urlString = [NSString stringWithFormat:@"/enocloud/common/lookup/%@",self.lookup];
        [[NetWorkAPIManager defaultManager] commonGET:urlString parm:@{} registerClass:[LookUp class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.messages = [NSArray arrayWithArray:responseObj.data];
            [strongSelf showPopView];
            
        } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CommonTool showError:error];
        }];

        
        
    }else if (self.queryMode == ComplexBoxQueryHint) {
        NSString * urlString = [NSString stringWithFormat:@"/enocloud/common/hint/%@",self.hint];
        [[NetWorkAPIManager defaultManager] commonGET:urlString parm:@{} registerClass:[Hint class] Success:^(NSURLSessionDataTask * _Nonnull task, ResponseObject * _Nonnull responseObj) {
            __strong typeof(self) strongSelf = weakSelf;
            strongSelf.messages = [NSArray arrayWithArray:responseObj.data];
            [strongSelf showPopView];
            
        } Failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [CommonTool showError:error];
        }];
    }
}

-(void)showPopView
{
    NSMutableArray * popStrings = [NSMutableArray array];
    if (self.queryMode == ComplexBoxQueryLookup) {
        for (LookUp * ainfo in self.messages) {
            [popStrings addObject:ainfo.message?ainfo.message:@""];
        }
    }else if (self.queryMode == ComplexBoxQueryHint)
    {
        for (Hint * ainfo in self.messages) {
            [popStrings addObject:ainfo.name?ainfo.name:@""];
        }
    }
    
    PopViewController * popCtrl = [[PopViewController alloc] initWithTitle:self.popTitle Data:popStrings];
    popCtrl.delegate = self;
    
    if (self.viewController) {
        [popCtrl showIn:self.viewController];
    }else {
        [popCtrl showIn:[UIApplication sharedApplication].delegate.window.rootViewController];
    }
}

-(void)popview:(PopViewController *)popview disSelectRowAtIndex:(NSInteger)index
{
    self.selectedItem = [self.messages objectAtIndex:index];
    self.textField.text = [self getTextFromItem:self.selectedItem];
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBox:didTextChanged:)]) {
        [self.boxDelegate complexBox:self didTextChanged:self.textField.text];
    }
}

-(NSString *)getTextFromItem:(id)item
{
    NSString * string = @"";
    switch (self.queryMode) {
        case ComplexBoxQueryLookup:
        {
            LookUp * lookup = (LookUp *)item;
            string = lookup.message;
        }
            break;
        case ComplexBoxQueryHint:
        {
            Hint * hint = (Hint *)item;
            string = hint.name;
        }
            break;
            
        default:
            break;
    }
    return string;
}


#pragma mark --Delegate


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL shouldEdit = YES;
    
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBoxShouldBeginEditing:)]) {
        shouldEdit = [self.boxDelegate complexBoxShouldBeginEditing:self];
    }
    
    if (shouldEdit) {
        if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBoxBeginEditing:)]) {
            [self.boxDelegate complexBoxBeginEditing:self];
        }
    }
    return shouldEdit;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    if (string.length <= 0) {
        //删除不用输入检查
        result = YES;
    }else {
        NSString * text = textField.text;
        text = [text stringByReplacingCharactersInRange:range withString:string];
        switch (self.inputCheckMode) {
            case ComplexBoxInput_NoCheck:
            {
                result = YES;
            }
                break;
            case ComplexBoxInput_Cellphone:
            {
                if (![CommonTool validateCellPhoneStr:text]) {
                    return NO;
                }
            }
                break;
            case ComplexBoxInput_Percent:
            {
                if (![CommonTool validatePercentStr:text]) {
                    return NO;
                }
            }
                break;
            case ComplexBoxInput_Float2Digit:
            {
                if (![CommonTool validateFloatStr:text withDigit:2]) {
                    return NO;
                }
            }
                break;
            default:
                break;
        }
    }
    
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBox:shouldChangeCharactersInRange:replacementString:)]) {
        result = [self.boxDelegate complexBox:self shouldChangeCharactersInRange:range replacementString:string];
    }
    
    return result;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBoxViewEndEditing:)]) {
        [self.boxDelegate complexBoxViewEndEditing:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [CommonTool resign];
    return YES;
}

- (void)textChanged:(UITextField *)textField
{
    if (self.boxDelegate && [self.boxDelegate respondsToSelector:@selector(complexBox:didTextChanged:)]) {
        [self.boxDelegate complexBox:self didTextChanged:self.textField.text];
    }
}

#pragma mark --懒加载

-(UILabel*)titleLab
{
    if (!_titleLab) {
        _titleLab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _titleLab.backgroundColor = [UIColor clearColor];
        _titleLab.font = [UIFont textFont];
        _titleLab.textColor = [UIColor darkTextColor];
    }
    return _titleLab;
}


-(UIView*)boxView
{
    if (!_boxView) {
        _boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _boxView.backgroundColor = [UIColor bgWhiteColor];
        _boxView.layer.cornerRadius = 8.0;
        _boxView.layer.masksToBounds = YES;
        _boxView.layer.borderColor = [UIColor borderColor].CGColor;
        _boxView.layer.borderWidth = 1.0;
    }
    return _boxView;
}

-(UITextField *)textField
{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.font = [UIFont textFont];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.textColor = [UIColor textColor];
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.tintColor = [UIColor tintColor];
        [_textField addTarget:self action:@selector(textChanged:) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

-(UILabel *)rightLab
{
    if (!_rightLab) {
        _rightLab = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 12, 0, 1, self.frame.size.height)];
        _rightLab.font = [UIFont textFont];
        _rightLab.textColor = [UIColor textColor];
        _rightLab.textAlignment = NSTextAlignmentRight;
    }
    return _rightLab;
}

-(UIImageView *)rightImage
{
    if (!_rightImage) {
        _rightImage = [[UIImageView alloc] init];
        [_rightImage setImage:[UIImage imageNamed:@"dropdown"]];
    }
    return _rightImage;
}

-(UIButton *)selectBtn
{
    if (!_selectBtn) {
        _selectBtn = [[UIButton alloc] init];
        _selectBtn.backgroundColor = [UIColor clearColor];
        [_selectBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectBtn;
}

@end
