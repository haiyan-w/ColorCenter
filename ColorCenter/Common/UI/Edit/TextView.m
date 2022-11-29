//
//  TextView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/4/21.
//

#import "TextView.h"

@interface TextView ()
@property(nullable, nonatomic,strong) UILabel *placeHolderLabel;
@end

@implementation TextView

-(void)initialize
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshPlaceholder) name:UITextViewTextDidChangeNotification object:self];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialize];
    }
    return self;
}

//-(void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self initialize];
//}

-(void)refreshPlaceholder
{
    if([[self text] length])
    {
        [self.placeHolderLabel setAlpha:0];
    }
    else
    {
        [self.placeHolderLabel setAlpha:1];
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
    [self refreshPlaceholder];
}

-(void)setFont:(UIFont *)font
{
    [super setFont:font];
    self.placeHolderLabel.font = self.font;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.placeHolderLabel sizeToFit];
    self.placeHolderLabel.frame = CGRectMake(self.textContainerInset.left + 5,self.textContainerInset.top, CGRectGetWidth(self.frame)-16, CGRectGetHeight(self.placeHolderLabel.frame));
}

-(void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    
    if ( self.placeHolderLabel == nil )
    {
        self.placeHolderLabel = [[UILabel alloc] init];
        self.placeHolderLabel.autoresizingMask = (UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight);
        self.placeHolderLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.font = self.font;
        self.placeHolderLabel.backgroundColor = [UIColor clearColor];
        self.placeHolderLabel.textColor = [UIColor colorWithRed:140/255.0 green:140/255.0 blue:140/255.0 alpha:140/255.0];
        self.placeHolderLabel.alpha = 0;
        [self addSubview:self.placeHolderLabel];
    }
    
    self.placeHolderLabel.text = self.placeholder;
    [self refreshPlaceholder];
}

-(id<UITextViewDelegate>)delegate
{
    [self refreshPlaceholder];
    return [super delegate];
}



@end
