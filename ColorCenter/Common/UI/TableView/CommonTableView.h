//
//  CommonTableView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/15.
//

/*CommonTableView使用说明
 网络请求数据时
 1.请求成功：emptyStyle = EmptyStyle_NoContent
            重新reloadData
 2.请求失败
            清空datasource
            emptyStyle = EmptyStyle_Error
            errorMsg = 请求返回错误信息
            重新reloadData
 */

#import "BaseTableView.h"
#import "EmptyView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CommonTableView : BaseTableView
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
