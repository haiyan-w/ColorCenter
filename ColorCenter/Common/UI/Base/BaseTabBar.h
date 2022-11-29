//
//  BaseTabBar.h
//  EnochCar
//
//  Created by 王海燕 on 2022/2/25.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseTabBar;

@protocol TabBarDelegate <NSObject>
@optional
- (BOOL)tabBar:(BaseTabBar *)tabBar shouldSelectItem:(UITabBarItem *)item atIndex:(NSInteger)index;
- (void)tabBar:(BaseTabBar *)tabBar didSelectItem:(UITabBarItem *)item atIndex:(NSInteger)index;
@end

@interface BaseTabBar : UIView
@property(nonatomic, assign) NSInteger selectIndex;
@end

NS_ASSUME_NONNULL_END
