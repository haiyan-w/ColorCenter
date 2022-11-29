//
//  SearchHistoryView.m
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import "SearchHistoryView.h"
#import "UIView+Frame.h"
#import "TagCell.h"
#import "DataBase.h"

@interface SearchHistoryView () <UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonatomic, strong) UILabel * titleLab;
@property (nonatomic, strong) UIButton * deleteBtn;
@property (nonatomic, strong) UICollectionView * collectionView;
@property (nonatomic, strong) NSArray * datasource;

@end

@implementation SearchHistoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self viewInit];
    }
    return self;
}

- (void)viewInit
{
    self.titleLab = [[UILabel alloc] init];
    self.titleLab.textColor = [UIColor darkTextColor];
    self.titleLab.font = [UIFont systemFontOfSize:16 weight:UIFontWeightMedium];
    self.titleLab.text = @"历史搜索";
    [self addSubview:self.titleLab];
    
    self.deleteBtn = [[UIButton alloc] init];
    [self.deleteBtn setImage:[UIImage imageNamed:@"delete_big"] forState:UIControlStateNormal];
    [self.deleteBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.deleteBtn];
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(96, 24);
    layout.minimumLineSpacing = 12;
    layout.minimumInteritemSpacing = 12;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) collectionViewLayout:layout];
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor clearColor];
    [self.collectionView registerClass:[TagCell class] forCellWithReuseIdentifier:@"TagCell"];
    self.collectionView.layer.masksToBounds = YES;
    [self addSubview:self.collectionView];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.deleteBtn.frame = CGRectMake(self.width - 32 - 16, 0, 32, 32);
    self.titleLab.frame = CGRectMake(24, 4, 80, 24);
    self.collectionView.frame = CGRectMake(24, 40, self.width - 2*24, self.height - 40);
}

- (void)refresh
{
    [[DataBase defaultDataBase] openSearchHistoryList];
    self.datasource = [[DataBase defaultDataBase] getAllSearchHistory];
    [self.collectionView reloadData];
    
    BOOL hide = (0 == self.datasource.count)?YES:NO;
    self.titleLab.hidden = hide;
    self.deleteBtn.hidden = hide;
}


- (void)deleteBtnClicked
{
    [[DataBase defaultDataBase] openSearchHistoryList];
    [[DataBase defaultDataBase] clearSearchHistory];
    
    [self refresh];
}

- (NSUInteger)historyCount
{
    return self.datasource.count;
}

#pragma mark collectionDelegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGSize currentLabelSize = [TagCell sizeWithText:self.datasource[indexPath.row]];
    return CGSizeMake(ceil(currentLabelSize.width), 24);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TagCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TagCell" forIndexPath:indexPath];
    cell.text = self.datasource[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.selectBlk) {
        self.selectBlk(self.datasource[indexPath.row]);
    }
}


@end
