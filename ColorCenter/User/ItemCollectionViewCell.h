//
//  ItemCollectionViewCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/27.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface Item : NSObject
@property (copy, nonatomic) NSString * name;
@property (copy, nonatomic) NSString * iconname;
- (instancetype)initWith:(NSString *)name icon:(NSString *)iconName;
@end

@interface ItemCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) Item * item;
@end

NS_ASSUME_NONNULL_END
