//
//  ColorPanelAngle.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "LookUp.h"
//#import "ColorPanel.h"

NS_ASSUME_NONNULL_BEGIN

@class ColorPanel;

@interface ColorPanelAngle : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) NSNumber * angle;
@property(nonatomic,readwrite,strong) ColorPanel * colorPanel;
@property(nonatomic,readwrite,strong) NSNumber * labA;//double
@property(nonatomic,readwrite,strong) NSNumber * labB;
@property(nonatomic,readwrite,strong) NSNumber * labC;
@property(nonatomic,readwrite,strong) NSNumber * labH;
@property(nonatomic,readwrite,strong) NSNumber * labL;

@property(nonatomic,readwrite,strong) NSNumber * rgbB;//int32
@property(nonatomic,readwrite,strong) NSNumber * rgbG;
@property(nonatomic,readwrite,strong) NSNumber * rgbR;

@property(nonatomic,readwrite,strong) NSNumber * xyzX;//double
@property(nonatomic,readwrite,strong) NSNumber * xyzY;
@property(nonatomic,readwrite,strong) NSNumber * xyzZ;

@property(nonatomic,readwrite,strong) NSNumber * nm400;//int32
@property(nonatomic,readwrite,strong) NSNumber * nm410;
@property(nonatomic,readwrite,strong) NSNumber * nm420;
@property(nonatomic,readwrite,strong) NSNumber * nm430;
@property(nonatomic,readwrite,strong) NSNumber * nm440;
@property(nonatomic,readwrite,strong) NSNumber * nm450;
@property(nonatomic,readwrite,strong) NSNumber * nm460;
@property(nonatomic,readwrite,strong) NSNumber * nm470;
@property(nonatomic,readwrite,strong) NSNumber * nm480;
@property(nonatomic,readwrite,strong) NSNumber * nm490;
@property(nonatomic,readwrite,strong) NSNumber * nm500;
@property(nonatomic,readwrite,strong) NSNumber * nm510;
@property(nonatomic,readwrite,strong) NSNumber * nm520;
@property(nonatomic,readwrite,strong) NSNumber * nm530;
@property(nonatomic,readwrite,strong) NSNumber * nm540;
@property(nonatomic,readwrite,strong) NSNumber * nm550;
@property(nonatomic,readwrite,strong) NSNumber * nm560;
@property(nonatomic,readwrite,strong) NSNumber * nm570;
@property(nonatomic,readwrite,strong) NSNumber * nm580;
@property(nonatomic,readwrite,strong) NSNumber * nm590;
@property(nonatomic,readwrite,strong) NSNumber * nm600;
@property(nonatomic,readwrite,strong) NSNumber * nm610;
@property(nonatomic,readwrite,strong) NSNumber * nm620;
@property(nonatomic,readwrite,strong) NSNumber * nm630;
@property(nonatomic,readwrite,strong) NSNumber * nm640;
@property(nonatomic,readwrite,strong) NSNumber * nm650;
@property(nonatomic,readwrite,strong) NSNumber * nm660;
@property(nonatomic,readwrite,strong) NSNumber * nm670;
@property(nonatomic,readwrite,strong) NSNumber * nm680;
@property(nonatomic,readwrite,strong) NSNumber * nm690;
@property(nonatomic,readwrite,strong) NSNumber * nm700;

@end

NS_ASSUME_NONNULL_END
