//
//  commonTabView.h
//  EnochCar
//
//  Created by 王海燕 on 2021/5/19.
//

#import <UIKit/UIKit.h>
#import "CommonTabItem.h"
#import "BadgeView.h"

NS_ASSUME_NONNULL_BEGIN


@class CommonTabView;

@protocol CommonTabViewDelegate <NSObject>

@optional

-(void)tabview:(CommonTabView *)tabview indexChanged:(NSInteger )index;

- (BOOL)tabView:(CommonTabView *)tabBar shouldSelectAtIndex:(NSInteger)index;
- (void)tabView:(CommonTabView *)tabBar didSelectAtIndex:(NSInteger)index;

@end


@interface CommonTabView : UIView
@property (nonatomic, weak, nullable) id <CommonTabViewDelegate> delegate;
@property(nullable, nonatomic, copy) NSArray<CommonTabItem *> *items;
@property(readwrite, nonatomic, assign) NSInteger index;
@property(nullable, nonatomic, strong) UIView *thumbView;    //滑动视图
@property(nonatomic,readwrite,assign)BOOL needSeparation;    /* 是否需要分隔线*/

@property(nonatomic,readwrite,assign)BOOL showBadge;    /* 是否显示右上角提示数字*/
@property(nonatomic,readwrite,assign)CGFloat badgeHeight;
@property(nonatomic,readwrite,assign)CGPoint badgeOffset;    /* 右上角提示数字的偏移位置*/
@property(nonatomic,readwrite,assign)CGFloat leftPadding;
@property(nonatomic,readwrite,assign)CGFloat rightPadding;

@property(nonatomic,readwrite,assign)CGFloat itemSpace;

-(instancetype)initWithFrame:(CGRect)frame target:(id<CommonTabViewDelegate>)delegate;
-(void)setNormalColor:(UIColor *)normalColor;
-(void)setSelectedColor:(UIColor *)selectedColor;
-(void)setFont:(UIFont *)font;
-(void)setSelectedFont:(UIFont *)font;

-(void)configBadge:(int )badgeCount atIndex:(int)index topOffsetFromTextTop:(CGFloat)topOffset  rightOffsetFormTextRight:(CGFloat)rightOffset;

@end

NS_ASSUME_NONNULL_END
