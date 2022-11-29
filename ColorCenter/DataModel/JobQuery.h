//
//  JobQuery.h
//  ColorCenter
//
//  Created by 王海燕 on 2022/11/14.
//

#import "BaseModel.h"
#import "ColorPanelAngle.h"

NS_ASSUME_NONNULL_BEGIN

@interface JobQuery : BaseModel
@property(nonatomic,readwrite,strong) NSNumber * id;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle15;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle45;
@property(nonatomic,readwrite,strong) ColorPanelAngle * angle110;
@property(nonatomic,readwrite,copy) NSString * colorCode;
@property(nonatomic,readwrite,copy) NSString * colorName;
@property(nonatomic,readwrite,copy) NSString * ownerName;
@property(nonatomic,readwrite,copy) NSString * serialNo;
@property(nonatomic,readwrite,copy) NSString * spectroJobNo;
@property(nonatomic,readwrite,copy) NSString * vehicleSpec;
@property(nonatomic,readwrite,strong) NSNumber * year;
@property(nonatomic,readwrite,strong) NSNumber * formulaCount;

@property(nonatomic,readwrite,strong) LookUp * status;
@property(nonatomic,readwrite,strong) LocalDateTime * preparedDatetime;

- (BOOL)isFinished;
@end

NS_ASSUME_NONNULL_END
