//
//  DeviceCollectionViewCell.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/10/19.
//

#import <UIKit/UIKit.h>
#import "Spectro.h"

NS_ASSUME_NONNULL_BEGIN

@interface DeviceCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) Spectro * spectro;
@property (nonatomic, assign) BOOL isConnected;
@end

NS_ASSUME_NONNULL_END
