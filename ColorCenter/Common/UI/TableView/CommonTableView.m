//
//  CommonTableView.m
//  EnochCar
//
//  Created by 王海燕 on 2022/8/15.
//

#import "CommonTableView.h"

@interface CommonTableView ()

@end

@implementation CommonTableView

-(instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self dataInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self dataInit];
    }
    return self;
}

- (void)dataInit
{
    self.emptyText = @"暂无内容";
    self.emptyImgName = @"empty_noContent";
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
    
    id <UITableViewDataSource> dataSource = self.dataSource;

    if ([dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [dataSource numberOfSectionsInTableView:self];
    }
    
    if ([dataSource respondsToSelector:@selector(tableView:numberOfRowsInSection:)]) {
        for (int i=0; i<sections; i++) {
            rows += [dataSource tableView:self numberOfRowsInSection:i];
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
    }
    
}

@end
