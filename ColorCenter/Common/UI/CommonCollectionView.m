//
//  CommonCollectionView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import "CommonCollectionView.h"

@implementation CommonCollectionView

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
}

-(void)reloadData
{
    [self.emptyView removeFromSuperview];
    self.emptyView = nil;
    [super reloadData];
    [self fillEmptyView];
}

-(void)fillEmptyView {
    
    NSInteger sections = 1;
    NSInteger rows = 0;
    
    id <UICollectionViewDataSource> dataSource = self.dataSource;

    if ([dataSource respondsToSelector:@selector(numberOfSectionsInCollectionView:)]) {
        sections = [dataSource numberOfSectionsInCollectionView:self];
    }
    
    if ([dataSource respondsToSelector:@selector(collectionView:numberOfItemsInSection:)]) {
        for (int i=0; i<sections; i++) {
            rows += [dataSource collectionView:self numberOfItemsInSection:i];
        }
    }
    
    if (rows == 0) {
        if (![self.subviews containsObject:self.emptyView]) {
            
            CGRect frame =CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            __weak typeof(self) weakSelf = self;
            switch (self.emptyStyle) {
                case EmptyStyle_NoContent:
                {
                    self.emptyView = [[EmptyView alloc] initWithFrame:frame image:self.emptyImgName text:self.emptyText linkText:self.emptyLinkText linkOperation:^{
                        __strong typeof(self) strongSelf = weakSelf;
                        if (strongSelf.linkBlock) {
                            strongSelf.linkBlock();
                        }
                    }];
                }
                    break;
                case EmptyStyle_Error:
                {
                    self.emptyView = [[EmptyView alloc] initWithFrame:frame image:@"empty_noContent" text:self.errorMsg linkText:self.emptyLinkText?self.emptyLinkText:@"点击重试" linkOperation:^{
                        __strong typeof(self) strongSelf = weakSelf;
                        if (strongSelf.refreshBlock) {
                            strongSelf.refreshBlock();
                        }
                    }];
                }
                    break;
                default:
                    break;
            }
            
            if (self.coverViewBgColor) {
                self.emptyView.backgroundColor = self.coverViewBgColor;
            }
            
            [self addSubview:self.emptyView];
        }
    }
    else{
        [self.emptyView removeFromSuperview];
        self.emptyView = nil;
    }
    
}


@end
