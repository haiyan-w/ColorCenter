//
//  ColorPanel.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "Spectro.h"
#import "ColorPanelAngle.h"

NS_ASSUME_NONNULL_BEGIN

@interface ColorPanel : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,assign) float graininess;//double
@property(nonatomic,readwrite,copy) NSString * preparedDatetime;
@property(nonatomic,readwrite,strong) Spectro * spectro;
@property(nonatomic,readwrite,copy) NSString * spectroJobNo;
@property(nonatomic,readwrite,strong) NSArray <ColorPanelAngle *>* angles;
@end

NS_ASSUME_NONNULL_END
