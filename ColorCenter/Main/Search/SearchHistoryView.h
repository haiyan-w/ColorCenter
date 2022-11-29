//
//  SearchHistoryView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchHistoryView : UIView
@property (nonatomic, copy) void (^selectBlk)(NSString * text);

- (void)refresh;
- (NSUInteger)historyCount;

@end

NS_ASSUME_NONNULL_END
