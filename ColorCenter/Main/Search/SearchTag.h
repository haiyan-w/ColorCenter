//
//  SearchTag.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchTag : UIView
@property (nonatomic, copy) NSString * text;
@property (nonatomic, copy) void(^deleteBlk)(void);
+(CGSize)sizeWithText:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
