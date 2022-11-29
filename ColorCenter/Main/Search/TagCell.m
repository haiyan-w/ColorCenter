//
//  TagCell.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/16.
//

#import "TagCell.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "TouchView.h"

@interface TagCell()
@property (nonatomic,strong)TouchView * bgView;
@property (nonatomic,strong)UILabel * label;
@end

@implementation TagCell

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

-(void)viewInit
{
    self.bgView = [[TouchView alloc] init];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 12;
    self.bgView.layer.masksToBounds = YES;
    [self addSubview:self.bgView];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 54, 24)];
    self.label.textColor = [UIColor textColor];
    self.label.font = [UIFont tipFont];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self.bgView addSubview:self.label];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    self.bgView.frame = self.bounds;
    self.label.frame = CGRectMake(8, (self.frame.size.height - 24)/2, (self.frame.size.width - 2*8), 24);
}

-(void)setText:(NSString *)text
{
    _text = text;
    self.label.text = [NSString stringWithFormat:@"%@",text?text:@""];
}


+(CGSize)sizeWithText:(NSString *)text
{
    NSString * tagtext = [NSString stringWithFormat:@"#%@",text?text:@""];
    NSMutableAttributedString * attrAtr = [[NSMutableAttributedString alloc] initWithString:tagtext attributes:@{NSFontAttributeName:[UIFont tipFont]}];
    CGRect rect = [attrAtr boundingRectWithSize:CGSizeMake(300, 24) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return CGSizeMake(rect.size.width + 2*8, rect.size.height);
}

@end
