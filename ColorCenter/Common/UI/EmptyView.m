//
//  EmptyView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/2.
//

#import "EmptyView.h"
#import "UIColor+CustomColor.h"

@interface EmptyView()<UITextViewDelegate>
@property(nonatomic,strong) UIImageView * imageView;
@property(nonatomic,strong) UITextView * textView;
@end

@implementation EmptyView

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName text:(NSString*)text linkText:(NSString *)linkText linkOperation:(void(^)(void))linkBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupWithImage:imageName text:text linkText:linkText];
        
        self.linkBlock = linkBlock;
    }
    return self;
}


-(void)setupWithImage:(NSString *)imgname text:(NSString*)text linkText:(NSString * )linkText
{
    self.backgroundColor = [UIColor clearColor];
    
    if (!imgname) {
        imgname  = @"empty_noContent";
    }
    
    if (!text) {
        text  = @"暂无内容";
    }
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 160, 126)];
    self.imageView.image = [UIImage imageNamed:imgname];
    self.imageView.center = CGPointMake(self.center.x, self.center.y*2/3);

    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, self.frame.size.width - 2*20, 40)];
    self.textView.textAlignment = NSTextAlignmentCenter;
    self.textView.textColor = [UIColor textColor];
    self.textView.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    self.textView.center = CGPointMake(self.imageView.center.x, CGRectGetMaxY(self.imageView.frame)+24);
    self.textView.backgroundColor = [UIColor clearColor];
    self.textView.editable = NO;
    self.textView.delegate = self;
    
    self.textView.linkTextAttributes = @{          // 单独在 UITextView 设置链接的颜色与字体
        NSForegroundColorAttributeName : [UIColor tintColor]
    };

    [self addSubview:self.imageView];
    [self addSubview:self.textView];
    
    //添加逗号
    if (text.length > 0 && linkText.length > 0) {
        text = [NSString stringWithFormat:@"%@，",text];
    }
    
    NSMutableAttributedString *subTitleString = [[NSMutableAttributedString alloc]
        initWithString:text
        attributes:@{
            NSForegroundColorAttributeName:[UIColor textColor]
        }
    ];
    
    if (linkText.length > 0) {
        NSMutableAttributedString *urlString = [[NSMutableAttributedString alloc]
            initWithString:linkText];
        [urlString addAttribute:NSLinkAttributeName value:@"protocol://" range:NSMakeRange(0, urlString.length)];
        [subTitleString appendAttributedString:urlString];
    }
    [subTitleString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14 weight:UIFontWeightRegular] range:NSMakeRange(0, subTitleString.length)];
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle1.alignment = NSTextAlignmentCenter;
    [subTitleString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, subTitleString.length)];
    self.textView.attributedText = subTitleString;
    
}

-(void)setText:(NSString *)text
{
    self.textView.text = text;
}


-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange interaction:(UITextItemInteraction)interaction
{
    if ([[URL scheme] isEqualToString:@"protocol"]) {
        // 找到我们之前设置的协议名
        if (self.linkBlock) {
            self.linkBlock();
        }
            return NO;
    }
        
    return YES;
}

@end
