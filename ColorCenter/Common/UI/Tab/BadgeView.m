//
//  BadgeView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/4/24.
//

#import "BadgeView.h"

@interface BadgeView()
@property(nullable, nonatomic,strong) UIImageView *bgImage;
@property(nullable, nonatomic,strong) UILabel *label;
@end

@implementation BadgeView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(void)viewInit
{
    UIImage * image = [UIImage imageNamed:@"badge"];
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    self.bgImage = [[UIImageView alloc] initWithImage:image];
    [self addSubview:self.bgImage];
    
    self.label = [[UILabel alloc] init];
    self.label.font = [UIFont systemFontOfSize:10 weight:UIFontWeightRegular];
    self.label.textColor = [UIColor whiteColor];
    self.label.backgroundColor = [UIColor clearColor];
    [self addSubview:self.label];
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;
    [self layoutSelf];
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5) resizingMode:UIImageResizingModeStretch];
    self.bgImage.image = image;
}

-(void)layoutSelf
{
    [self.label sizeToFit];
    
    CGRect orgFrame = self.frame;
    self.frame = CGRectMake(orgFrame.origin.x, orgFrame.origin.y, self.label.frame.size.width + 4 + 4, self.bounds.size.height);
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.bgImage.frame = self.bounds;
    
    float space = (self.bounds.size.height - self.label.frame.size.height)/2;
    self.label.frame = CGRectMake(4, space, self.bounds.size.width - 2*4, self.bounds.size.height - 2*space);
}

@end
