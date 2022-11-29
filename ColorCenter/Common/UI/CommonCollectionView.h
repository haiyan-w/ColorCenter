//
//  CommonCollectionView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/3.
//

#import <UIKit/UIKit.h>
#import "EmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonCollectionView : UICollectionView
@property(nonatomic,nullable,strong)EmptyView * emptyView;
@property(nonatomic,assign)EmptyStyle emptyStyle;

@property(nonatomic,copy) NSString * emptyImgName;
@property(nonatomic,copy) NSString * emptyText;
@property(nonatomic,copy) NSString * emptyLinkText;
@property(nonatomic,copy) OperateBlock linkBlock;
@property(nonatomic,copy) OperateBlock refreshBlock;
@property(nonatomic,copy) NSString * errorMsg;//错误提示
@property(nonatomic,readwrite,strong) UIColor * coverViewBgColor;//emptyView背景色（nil 则不设置）
@end

NS_ASSUME_NONNULL_END
