//
//  RefreshView.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RefreshView : UIView
@property (nonatomic, copy) NSString * normalText;
@property (nonatomic, copy) NSString * endText;
@property (nonatomic, assign) BOOL end;
@property (nonatomic, copy) NSString * iconName;
@end

NS_ASSUME_NONNULL_END
