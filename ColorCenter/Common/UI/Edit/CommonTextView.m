//
//  CommonTextView.m
//  EnochCar
//
//  Created by 王海燕 on 2021/7/26.
//

#import "CommonTextView.h"
#import "CommonDefine.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"

@interface CommonTextView()<UITextViewDelegate>
@property (nonatomic,strong) UILabel * titleLabel;
@property (nonatomic,strong) UIView * boxView;
@property (nonatomic,strong) UILabel * placeLabel;
@property (nonatomic,strong) UITextView * textview;
@property (nonatomic,strong) UILabel * textNumLabel; //展示当前字数
@end

@implementation CommonTextView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.maxTextNumber = 300;
    self.hideTextNumber = NO;
    
    [self viewInit];
    
    [self layoutSubviews];
}

-(instancetype)init
{
    self = [self initWithFrame:CGRectZero title:@"" placeHolder:@""];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame title:@"" placeHolder:@""];
    if (self) {
        
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)titleStr placeHolder:(NSString *)placeHolderStr
{
    self = [super initWithFrame:frame];
    if (self) {
        self.maxTextNumber = 300;
        self.hideTextNumber = NO;
        self.titleStr = titleStr;
        self.placeHolder = placeHolderStr;
        
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        
        [self viewInit];
        [self layoutSubviews];
    }
    
    return self;
}

-(void)viewInit
{
    self.backgroundColor = [UIColor whiteColor];
    self.layer.cornerRadius = 4;
    
    NSInteger space = 12;

    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, self.frame.size.width - 2*12, 24)];
    self.titleLabel.text = self.titleStr;
    self.titleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.titleLabel.textColor = [UIColor textColor];
    [self addSubview:self.titleLabel];
    
    self.boxView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 10)];
    self.boxView.layer.borderColor = [UIColor borderColor].CGColor;
    self.boxView.layer.borderWidth = 1.0;
    self.boxView.layer.cornerRadius = 4.0;
    self.boxView.layer.masksToBounds = YES;
    [self addSubview:self.boxView];
    
    self.placeLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height +space), self.frame.size.width - 2*12, 13)];
    self.placeLabel.text = self.placeHolder;
    self.placeLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.placeLabel.textColor = [UIColor lightTextColor];
    [self.boxView addSubview:self.placeLabel];
    
    self.textview = [[UITextView alloc] initWithFrame:CGRectMake(12, self.placeLabel.frame.origin.y - 2, self.frame.size.width - 2*12, self.frame.size.height - self.placeLabel.frame.origin.y - 2 -8 - 16)];
    self.textview.delegate = self;
    self.textview.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
    self.textview.textColor = [UIColor textColor];
    self.textview.backgroundColor = [UIColor clearColor];
    self.textview.tintColor = [UIColor tintColor];
    self.textview.textContainerInset = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.boxView addSubview:self.textview];
    
    self.textNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, self.textview.frame.origin.y + self.textview.frame.size.height, self.frame.size.width - 2*12, 16)];
    self.textNumLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    self.textNumLabel.textColor = [UIColor lightTextColor];
    self.textNumLabel.textAlignment = NSTextAlignmentRight;
    self.textNumLabel.text = [NSString stringWithFormat:@"0/%@",[NSNumber numberWithInteger:self.maxTextNumber]];
    [self.boxView addSubview:self.textNumLabel];
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat spaceH = 16;//控件水平间隔
    CGFloat spaceV = 12;//控件垂直间隔
    CGFloat boxOrgY = 0;
    CGFloat left = 12;

    if (self.titleStr.length > 0) {
        self.titleLabel.frame = CGRectMake(left, 0, self.frame.size.width-2*left, 24);
        boxOrgY = (self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + 4);
        self.boxView.frame = CGRectMake(0, boxOrgY,self.frame.size.width, self.frame.size.height - boxOrgY);
    }else {
        self.titleLabel.frame = CGRectMake(0, 0, self.frame.size.width, 0);
        self.boxView.frame = CGRectMake(0, boxOrgY,self.frame.size.width, self.frame.size.height - boxOrgY);
    }
    
    self.placeLabel.frame = CGRectMake(spaceH, spaceV, (self.boxView.frame.size.width - 2*spaceH), 16);
    
    if (!self.hideTextNumber) {
        self.textNumLabel.frame = CGRectMake(12, (self.boxView.frame.size.height -20 - 7), (self.boxView.frame.size.width -2*12), 20);
        self.textview.frame = CGRectMake(spaceH, spaceV, (self.boxView.frame.size.width - 2*spaceH), (self.textNumLabel.frame.origin.y - 4 - spaceV));
    }else {
        self.textNumLabel.frame = CGRectMake(12, (self.boxView.frame.size.height -20 - 7), (self.boxView.frame.size.width -2*12), 0);
        self.textview.frame = CGRectMake(spaceH, spaceV, (self.boxView.frame.size.width - 2*spaceH), (self.boxView.frame.size.height - 2*spaceV));
    }
        
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self layoutSubviews];
}

-(void)setMaxTextNumber:(NSInteger)maxTextNumber
{
    _maxTextNumber = maxTextNumber;
    
    self.textNumLabel.text = [NSString stringWithFormat:@"0/%@",[NSNumber numberWithInteger:self.maxTextNumber]];
}
//-(void)layoutSubviews
//{
//    [super layoutSubviews];
//    CGFloat space = 12;
//    CGFloat OrgY = space;
//    if (self.titleStr.length > 0) {
//        self.titleLabel.frame = CGRectMake(space, space, self.frame.size.width - 2*space, 18);
//        OrgY = self.titleLabel.frame.origin.y + self.titleLabel.frame.size.height + space;
//    }
//    self.placeLabel.frame = CGRectMake(space, OrgY, self.frame.size.width - 2*space, 13);
//    self.textview.frame = CGRectMake(space, self.placeLabel.frame.origin.y - 2, self.frame.size.width - 2*space, self.frame.size.height - self.placeLabel.frame.origin.y - 2 -8 - 16);
//    self.textNumLabel.frame = CGRectMake(space, self.textview.frame.origin.y + self.textview.frame.size.height, self.frame.size.width - 2*space, 16);
//}

-(NSString*)getText
{
    return self.textview.text;
}

-(void)setText:(NSString*)text
{
    self.textview.text = text; 
    
    if (!self.textview.text || self.textview.text.length <= 0) {
        self.placeLabel.text = self.placeHolder;
        
    }else {
        self.placeLabel.text = @"";
    }
    
    self.textNumLabel.text = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:self.textview.text.length],[NSNumber numberWithInteger:self.maxTextNumber]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonTextView:didTextChanged:)]) {
        [self.delegate commonTextView:self didTextChanged:text];
    }
}

-(void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    self.placeLabel.text = placeHolder;
}

-(void)setEnabled:(BOOL)enabled
{
    _enabled = enabled;
    
    if (_enabled) {
        self.boxView.backgroundColor = [UIColor whiteColor];
        self.boxView.layer.borderWidth = 1.0;
        self.textview.editable = _enabled;
    }else {
        self.boxView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1];
        self.boxView.layer.borderWidth = 0;
        self.textview.editable = _enabled;
    }
    
}

-(void)setBorder:(BOOL)border
{
    _border = border;
    if (_border) {
        self.boxView.layer.borderColor = [UIColor borderColor].CGColor;
        self.boxView.layer.borderWidth = 1.0;
    }else {
        self.boxView.layer.borderWidth = 0;
    }
}

-(void)setTextViewTag:(NSInteger)tag
{
    self.textview.tag = tag;
}

-(void)beginEditing
{
    self.placeLabel.text = @"";
}

-(void)endEditing
{
    if (!self.textview.text || self.textview.text.length <= 0) {
        self.placeLabel.text = self.placeHolder;
        
    }else {
        self.placeLabel.text = @"";
    }
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    [self beginEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonTextViewBeginEditing:)]) {
        [self.delegate commonTextViewBeginEditing:self];
    }
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //表情过滤方法不太准确
//    if ([CommonTool isContainsEmoji:text]) {
//        return NO;
//    }
    
    if ((self.textview.text.length + text.length) > self.maxTextNumber) {
        return NO;
    }else {
        return YES;
    }
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (!self.textview.text || self.textview.text.length <= 0) {
        self.placeLabel.text = self.placeHolder;
        
    }else {
        self.placeLabel.text = @"";
    }
    
    self.textNumLabel.text = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:self.textview.text.length],[NSNumber numberWithInteger:self.maxTextNumber]];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonTextView:didTextChanged:)]) {
        [self.delegate commonTextView:self didTextChanged:textView.text];
    }
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [self endEditing];
    if (self.delegate && [self.delegate respondsToSelector:@selector(commonTextViewEndEditing:)]) {
        [self.delegate commonTextViewEndEditing:self];
    }
    return YES;
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
//{
//    if (!self.textview.text || self.textview.text.length <= 0) {
//        self.placeLabel.text = self.placeHolder;
//
//    }else {
//        self.placeLabel.text = @"";
//    }
//    self.textNumLabel.text = [NSString stringWithFormat:@"%@/%@",[NSNumber numberWithInteger:self.textview.text.length],[NSNumber numberWithInteger:self.maxTextNumber]];
//}


- (BOOL)isFirstResponder
{
    return [self.textview isFirstResponder];
}

@end
