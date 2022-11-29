//
//  TagCell.h
//  EnochCar
//
//  Created by 王海燕 on 2022/3/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


typedef void (^SelectBlock)(NSString * text);


@interface TagCell : UICollectionViewCell
@property (nonatomic,copy) NSString * text;

+(CGSize)sizeWithText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
