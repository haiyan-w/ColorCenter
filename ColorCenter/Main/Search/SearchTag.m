//
//  SearchTag.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/23.
//

#import "SearchTag.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"
#import "UIFont+CustomFont.h"

@interface SearchTag ()
@property (nonatomic, strong)UILabel * label;
@property (nonatomic, strong)UIButton * deleteBtn;
@end

@implementation SearchTag

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
    self.layer.cornerRadius = 12.0;
    self.layer.borderWidth = 1.0;
    self.layer.borderColor = [UIColor tintColor].CGColor;
    self.backgroundColor = [UIColor fillTintColor];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor tintColor];
    self.label.font = [UIFont tipFont];
    [self addSubview:self.label];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete_green"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(8, 2, self.width - 8 - 24, self.height - 2*2);
    self.deleteBtn.frame = CGRectMake(self.width - 8 - 16, (self.height - 16)/2, 16, 16);
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;
}

- (void)deleteBtnClicked
{
    if (self.deleteBlk) {
        self.deleteBlk();
    }
}


+(CGSize)sizeWithText:(NSString *)text
{
    NSString * tagtext = [NSString stringWithFormat:@"#%@",text?text:@""];
    NSMutableAttributedString * attrAtr = [[NSMutableAttributedString alloc] initWithString:tagtext attributes:@{NSFontAttributeName:[UIFont tipFont]}];
    CGRect rect = [attrAtr boundingRectWithSize:CGSizeMake(150, 24) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(rect.size.width + 8 + 24, rect.size.height);
}


@end
