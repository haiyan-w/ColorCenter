//
//  TextTabView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/12.
//

#import "TextTabView.h"
#import "CommonTool.h"
#import "UIColor+CustomColor.h"

@implementation TextTabItem

-(instancetype)initWithTitle:(NSString *)title
{
    self = [super init];
    if (self) {
        self.attrTitle  = [self normalTabAttrWith:title];
        self.selectedAttrTitle = [self selectedTabAttrWith:title];
    }
    return self;
}

-(instancetype)initWithAttrTitle:(NSAttributedString *)attrTitle selectAttrTitle:(NSAttributedString *)selectAttrTitle
{
    self = [super init];
    if (self) {
        self.attrTitle  = attrTitle;
        self.selectedAttrTitle = selectAttrTitle;
    }
    return self;
}

- (NSAttributedString *)normalTabAttrWith:(NSString *)text
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:text];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor textColor], NSFontAttributeName : [UIFont systemFontOfSize:16 weight:UIFontWeightRegular]} range:range];
    return attr;
}

- (NSAttributedString *)selectedTabAttrWith:(NSString *)text
{
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [text rangeOfString:text];
    [attr addAttributes:@{NSForegroundColorAttributeName : [UIColor darkTextColor], NSFontAttributeName : [UIFont systemFontOfSize:20 weight:UIFontWeightMedium]} range:range];
    
    return attr;
}


@end


@interface TextTabView()
@property(readwrite, nonatomic, strong) NSMutableArray *btnArray;
@end


@implementation TextTabView


-(instancetype)initWithFrame:(CGRect)frame target:(id<TabViewDelegate>)delegate{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = delegate;
        self.index = 0;
    }
    return self;
}

-(void)setThumbView:(UIView *)thumbView
{
    [_thumbView removeFromSuperview];
    _thumbView = thumbView;

    [self insertSubview:thumbView atIndex:0];
}


- (void)setItems:(NSArray<TextTabItem *> *)items
{
    _items = items;
    [self configItems];
//    [self addSubview:_thumbView];
    self.index = self.index;
}



- (void)configItems
{
    for (UIView * view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [view removeFromSuperview];
        };
    }
    
    for (int i = 0; i < self.items.count ; i++) {
        TextTabItem * item = self.items[i];
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [btn setAttributedTitle:item.attrTitle forState:UIControlStateNormal];
        btn.tag = i;
        [btn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [self.btnArray addObject:btn];
    }
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
    
- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    float orgX = 0;
    float btnH = self.frame.size.height;
    for (int i = 0; i < self.items.count; i++) {
        TextTabItem * item = self.items[i];
        UIButton * btn = self.btnArray[i];
        CGRect textRect = [item.attrTitle boundingRectWithSize:CGSizeMake(200, btnH) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        if (i == self.index) {
            textRect = [item.selectedAttrTitle boundingRectWithSize:CGSizeMake(200, btnH) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        }
        if (0 == i) {
            btn.frame = CGRectMake(orgX, 0, self.padding + textRect.size.width + self.itemSpace/2, btnH);
        }else if ((self.items.count - 1) == i) {
            btn.frame = CGRectMake(orgX, 0, textRect.size.width + self.itemSpace/2, btnH);
        }else {
            btn.frame = CGRectMake(orgX, 0, textRect.size.width + self.itemSpace, btnH);
        }
        
        orgX += btn.frame.size.width;
    }
    
//    self.contentSize = CGSizeMake((orgX > self.frame.size.width)?orgX:self.frame.size.width, self.frame.size.height);
}

-(void)setIndex:(NSInteger)index
{
    [super setIndex:index];

    for ( int i = 0; i<self.btnArray.count;i++){
        TextTabItem * item = [_items objectAtIndex:i];
        UIButton * btn = self.btnArray[i];
        if (i == index)  {
            [btn setAttributedTitle:item.selectedAttrTitle forState:UIControlStateNormal];
        }else {
            [btn setAttributedTitle:item.attrTitle forState:UIControlStateNormal];
        }
    }
    
    [self layoutSubviews];

    //选中视图滑动
    __weak typeof(self) weakSelf = self;
    if (self.btnArray.count > index) {
        UIButton * btn = [self.btnArray objectAtIndex:index];
        [UIView animateWithDuration:0.2 animations:^{
            CGRect frame = weakSelf.thumbView.frame ;
            weakSelf.thumbView.frame = CGRectMake(btn.center.x-frame.size.width/2, frame.origin.y, frame.size.width, frame.size.height);
        }];
    }

    if (self.delegate && [self.delegate respondsToSelector:@selector(tabview:indexChanged:)]) {
        [self.delegate tabview:self indexChanged:index];
    }
}


@end
