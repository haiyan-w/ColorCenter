//
//  TextTabView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/8/12.
//

#import <UIKit/UIKit.h>
#import "BaseTabView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TextTabItem : NSObject
@property(nonatomic,readwrite,strong)NSAttributedString * attrTitle;
@property(nonatomic,readwrite,strong)NSAttributedString * selectedAttrTitle;

-(instancetype)initWithTitle:(NSString *)title;

-(instancetype)initWithAttrTitle:(NSAttributedString *)attrTitle selectAttrTitle:(NSAttributedString *)selectAttrTitle;


@end

@interface TextTabView : BaseTabView
@property(nonatomic,readwrite,assign)CGFloat padding;
@property(nonatomic,readwrite,assign)CGFloat itemSpace;
@property(nullable, nonatomic, copy) NSArray<TextTabItem *> *items;
@property(nullable, nonatomic, strong) UIView *thumbView;    //滑动视图

-(instancetype)initWithFrame:(CGRect)frame target:(id<TabViewDelegate>)delegate;
@end

NS_ASSUME_NONNULL_END
