//
//  TextTabScrollView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/12.
//

#import "TextTabScrollView.h"
#import "BaseScrollView.h"
#import "UIColor+CustomColor.h"
#import "UIView+Frame.h"

@interface TextTabScrollView () <TabViewDelegate, UIScrollViewDelegate>
@property(nullable, nonatomic, strong) BaseScrollView * scrollView;
@end

@implementation TextTabScrollView

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.tabbar = [[TextTabView alloc] initWithFrame:CGRectMake(0, 0, 200, 28) target:self];
    [self addSubview:self.tabbar];
    self.tabbar.itemSpace = 24;
    self.tabbar.padding = 24;
    
    UIView * thumb = [[UIView alloc] initWithFrame:CGRectMake(2, 20, 24, 8)];
    thumb.backgroundColor = [UIColor tintColor];
    thumb.layer.cornerRadius = 4;
    self.tabbar.thumbView = thumb;
    
    self.scrollView  = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, self.tabbar.bottom, self.width, self.height - self.tabbar.bottom)];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.tabbar.frame = CGRectMake(0, 0, self.width, 28);
    self.scrollView.frame = CGRectMake(0, self.tabbar.bottom, self.width, self.height - self.tabbar.bottom);
}

- (void)setItems:(NSArray<TextTabItem *> *)items
{
    _items = items;
    
    self.tabbar.items = items;
}

- (void)setViewArray:(NSArray<UIView *> *)viewArray
{
    _viewArray = viewArray;
    
//    for (UIView * subview in self.scrollView.subviews) {
//        [subview removeFromSuperview];
//    }
    
    for (int i = 0; i < viewArray.count; i++) {
        UIView * view = viewArray[i];
        view.frame = CGRectMake(self.scrollView.width * i, 0 ,self.scrollView.width, self.scrollView.height);
        [self.scrollView addSubview:view];
    }
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.width * viewArray.count, self.scrollView.height);
}

- (void)setIndex:(NSInteger)index
{
    _index = index;
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width * index, 0);
}

-(void)tabview:(BaseTabView *)tabview indexChanged:(NSInteger )index
{
    self.index = index;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGPoint point = scrollView.contentOffset;
    
    NSInteger page = point.x/scrollView.bounds.size.width;
    if (page < 0) {
        page = 0;
    } else if (page > (self.tabbar.items.count -1)) {
        page = self.tabbar.items.count -1;
    }
     
    [self.tabbar setIndex:page];
}


@end
