//
//  BaseTableView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/3/2.
//

#import "BaseTableView.h"
#import "MJRefresh.h"

@interface BaseTableView ()

@end

@implementation BaseTableView

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self BaseViewInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self BaseViewInit];
    }
    return self;
}

-(void)BaseViewInit
{
    self.backgroundColor = [UIColor clearColor];
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.bounces = YES;
    self.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
}



@end
