//
//  IconTextButton.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/31.
//

#import "IconTextButton.h"
#import "UIView+Frame.h"

@implementation IconTextButton


- (void)setIsIconRight:(BOOL)isIconRight
{
    _isIconRight = isIconRight;
    
    [self layoutSubviews];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.isIconRight) {
        // 图片上限靠着button的顶部
        CGRect templabelrect = self.titleLabel.frame;
        // 图片左右居中，也就是x坐标为button宽度的一半减去图片的宽度
        templabelrect.origin.x = 2;
        self.titleLabel.frame = templabelrect;
          
        CGRect tempimageviewrect = self.imageView.frame;
        // 文字label的x靠着button左侧(或距离多少)
        tempimageviewrect.origin.x = self.titleLabel.right + self.midSpace;
        self.imageView.frame = tempimageviewrect;
        
    }else {
        // 图片上限靠着button的顶部
        CGRect tempimageviewrect = self.imageView.frame;
        tempimageviewrect.origin.y = self.topSpace;
        // 图片左右居中，也就是x坐标为button宽度的一半减去图片的宽度
        tempimageviewrect.origin.x = (self.bounds.size.width - tempimageviewrect.size.width) / 2;
        self.imageView.frame = tempimageviewrect;
           CGRect templabelrect = self.titleLabel.frame;
        // 文字label的x靠着button左侧(或距离多少)
        templabelrect.origin.x = 2;
        // y靠着图片的下部
        templabelrect.origin.y = self.topSpace + self.imageView.frame.size.height + self.midSpace;
        // 宽度与button一致，或者自己改
        templabelrect.size.width = self.bounds.size.width - 4;
        // 高度等于button高度减去上方图片高度
        templabelrect.size.height = self.bounds.size.height - templabelrect.origin.y;
        self.titleLabel.frame = templabelrect;
    }
    
 
}

@end
