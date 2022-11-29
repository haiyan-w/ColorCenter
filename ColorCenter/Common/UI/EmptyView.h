//
//  EmptyView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    EmptyStyle_NoContent,
    EmptyStyle_Error,
}EmptyStyle;

typedef void(^OperateBlock)(void);

@interface EmptyView : UIView
@property(nonatomic,copy) OperateBlock linkBlock;//链接执行操作

-(instancetype)initWithFrame:(CGRect)frame image:(NSString *)imageName text:(NSString*)text linkText:(NSString *)linkText linkOperation:(void(^)(void))linkBlock;

@end

NS_ASSUME_NONNULL_END
