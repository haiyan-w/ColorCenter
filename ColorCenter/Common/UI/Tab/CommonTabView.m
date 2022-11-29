//
//  commonTabView.m
//  EnochCar
//
//  Created by 王海燕 on 2021/5/19.
//

#import "CommonTabView.h"
#import "UIColor+CustomColor.h"
#import "CommonTool.h"
#import "CommonTabItemView.h"


@interface CommonTabView()
@property(readwrite, nonatomic, strong) NSMutableArray<CommonTabItemView *> *viewArray;
@property(nonatomic,readwrite,strong)UIColor * normalColor;
@property(nonatomic,readwrite,strong)UIColor * selectedColor;
@property(nonatomic,readwrite,strong)UIFont * font;
@property(nonatomic,readwrite,strong)UIFont * selectedFont;
@end



@implementation CommonTabView

@synthesize index = _index;


-(instancetype)initWithFrame:(CGRect)frame target:(id<CommonTabViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        _delegate = delegate;
        _items = [NSMutableArray array];
        _viewArray = [NSMutableArray array];
        _normalColor = [UIColor textColor];
        _selectedColor = [UIColor customYellowColor];
        self.font = [UIFont boldSystemFontOfSize:14];
        self.index = 0;
    }
    return self;
}

-(void)setNormalColor:(UIColor *)normalColor
{
    _normalColor = normalColor;
}

-(void)setSelectedColor:(UIColor *)selectedColor
{
    _selectedColor = selectedColor;
}

-(void)setFont:(UIFont *)font
{
    _font = font;
}

-(void)setSelectedFont:(UIFont *)selectedFont
{
    _selectedFont = selectedFont;
}

-(void)setThumbView:(UIView *)thumbView
{
    [_thumbView removeFromSuperview];
    _thumbView = thumbView;
}

-(NSInteger)index
{
    return _index;
}


-(void)click:(UIButton *)sender
{
    [CommonTool resign];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:shouldSelectAtIndex:)]) {
        if ([self.delegate tabView:self shouldSelectAtIndex:sender.tag]) {
            
            self.index  = sender.tag;
            if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectAtIndex:)]) {
                [self.delegate tabView:self didSelectAtIndex:self.index];
            }
        }
    }else {
        self.index  = sender.tag;
        if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didSelectAtIndex:)]) {
            [self.delegate tabView:self didSelectAtIndex:self.index];
        }
    }
}

-(void)setItems:(NSArray<CommonTabItem *> *)items
{
    _items = items;
    _viewArray = [NSMutableArray array];
    
    [self addSubview:_thumbView];

    for (UIView * subview in self.subviews) {
        [subview removeFromSuperview];
    }

    for ( int i = 0; i<items.count;i++) {

        CommonTabItemView * view = [[CommonTabItemView alloc] init];
        view.tag = i;
        [view addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [_viewArray addObject:view];
        [self addSubview:view];

        if (self.needSeparation) {
            if ((items.count > 1) && (i != items.count-1)) {
                CGFloat width = self.frame.size.width/items.count;
                UIImageView * separator = [[UIImageView alloc] initWithFrame:CGRectMake(width*(i+1), (self.frame.size.height - 12)/2, 1, 12)];
                [separator  setImage:[UIImage imageNamed:@"separator"]];
                [self addSubview:separator];
            }
        }

    }

    if (self.thumbView) {
        [self addSubview:self.thumbView];
    }

    [self layoutSubviews];

    self.index  = self.index;

}

-(void)layoutSubviews
{
    [super layoutSubviews];

    float itemWidth = [self itemWidth];
    float itemX = self.leftPadding;
    float itemHeight = self.frame.size.height;

    for ( int i = 0; i<self.viewArray.count;i++) {
        CommonTabItemView * itemView = self.viewArray[i];
        CommonTabItem * item = self.items[i];
        if (item.width > 0) {
            itemWidth = item.width;
        }
        
        if (self.showBadge) {
            itemView.topPadding = self.badgeHeight;
        }
        itemView.frame = CGRectMake(itemX, 0, itemWidth, itemHeight);
        [itemView layoutSubviews];

        itemX += itemWidth + self.itemSpace;
        itemWidth = [self itemWidth];
    }
}

- (CGFloat)itemWidth {
    if (self.items && self.items.count >0) {
        
        return (self.frame.size.width-self.leftPadding-self.rightPadding - (self.itemSpace * (self.items.count -1)))/self.items.count;
    }
    return 0;
}


-(void)setIndex:(NSInteger)index
{
    _index = index;

    for ( int i = 0; i<_viewArray.count;i++){
        CommonTabItem * item = [_items objectAtIndex:i];
        CommonTabItemView * itemView = self.viewArray[i];

        BOOL selected = (itemView.tag == index)?YES:NO;
        if (selected) {
            itemView.badge.image = [UIImage imageNamed:@"badge"];
        }else {
            itemView.badge.image = [UIImage imageNamed:@"badge_unselect"];
        }
        

        if (item.style == CommonTabItemStyleText) {
            itemView.label.text = item.title;

            if (selected) {
                itemView.label.textColor = self.selectedColor;
                itemView.label.font = self.selectedFont;
            }else {
                itemView.label.textColor = self.normalColor;
                itemView.label.font = self.font;
            }

        }else if(item.style == CommonTabItemStyleImage){

            if (selected) {
                if (item.selectedImageName) {
                    itemView.imageView.image = [UIImage imageNamed:item.selectedImageName];
                }else {
                    itemView.imageView.image = [UIImage imageNamed:item.imageName];
                }
            }else {
                itemView.imageView.image = [UIImage imageNamed:item.imageName];
            }

        }else if (item.style == CommonTabItemStyleAttrText){
            if (selected) {
                itemView.label.attributedText = item.selectedAttrTitle;
            }else {
                itemView.label.attributedText = item.attrTitle;
            }

        }
    }

    //选中视图滑动
    __weak typeof(self) weakSelf = self;
    if (self.viewArray.count > index) {
        CommonTabItemView * itemView = [self.viewArray objectAtIndex:index];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = weakSelf.thumbView.frame ;
            weakSelf.thumbView.frame = CGRectMake(itemView.center.x-frame.size.width/2, frame.origin.y, frame.size.width, frame.size.height);
        }];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabview:indexChanged:)]) {
        [self.delegate tabview:self indexChanged:_index];
    }
}

- (void)configBadge:(int )badgeCount atIndex:(int)index topOffsetFromTextTop:(CGFloat)topOffset  rightOffsetFormTextRight:(CGFloat)rightOffset {
    
    if (index>=self.items.count || index>=self.viewArray.count) {
        return;
    }
    
    CommonTabItemView *itemView = [self.viewArray objectAtIndex:index];
    if (0 == badgeCount) {
        itemView.badge = nil;
    }else {
        BadgeView * badgeView = [[BadgeView alloc] initWithFrame:CGRectMake(0, 0, 20, 16)];
        badgeView.text = [NSString stringWithFormat:@"%@",(badgeCount>99)?@"99+":[NSNumber numberWithInt:badgeCount]];
        if (index != self.index) {
            badgeView.image = [UIImage imageNamed:@"badge_unselect"];
        }
        
        float itemWidth = [self itemWidth];
        CGSize size = badgeView.frame.size;
        badgeView.frame = CGRectMake(itemWidth/2+rightOffset, topOffset, size.width, size.height);
        itemView.badge = badgeView;
    }
 
}


@end
