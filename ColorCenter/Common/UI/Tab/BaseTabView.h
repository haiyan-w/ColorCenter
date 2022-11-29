//
//  BaseTabView.h
//  EnochCar
//
//  Created by 王海燕 on 2022/10/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class BaseTabView;

@protocol TabViewDelegate <NSObject>

@optional

-(void)tabview:(BaseTabView *)tabview indexChanged:(NSInteger )index;

- (BOOL)tabView:(BaseTabView *)tabBar shouldSelectAtIndex:(NSInteger)index;
- (void)tabView:(BaseTabView *)tabBar didSelectAtIndex:(NSInteger)index;

@end

@interface BaseTabView : UIView
@property(readwrite, nonatomic, assign) NSInteger index;

@property (nonatomic, weak, nullable) id <TabViewDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
